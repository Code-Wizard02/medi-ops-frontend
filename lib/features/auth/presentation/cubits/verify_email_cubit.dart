import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/app_result.dart';
import '../../application/use_cases/confirm_email.dart';
import '../../application/use_cases/resend_code.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/verification_code.dart';
import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit({
    required ConfirmEmail confirmEmailUseCase,
    required ResendCode resendCodeUseCase,
  })  : _confirmEmailUseCase = confirmEmailUseCase,
        _resendCodeUseCase = resendCodeUseCase,
        super(const VerifyEmailInitial());

  final ConfirmEmail _confirmEmailUseCase;
  final ResendCode _resendCodeUseCase;

  Future<void> submit({
    required String email,
    required String code,
  }) async {
    emit(const VerifyEmailLoading());

    final emailVO = Email(email);
    final codeVO = VerificationCode(code);

    final emailError = emailVO.validate();
    final codeError = codeVO.validate();

    if (emailError != null || codeError != null) {
      emit(VerifyEmailFailed(codeError ?? emailError ?? 'Datos inválidos'));
      return;
    }

    final result = await _confirmEmailUseCase(
      ConfirmEmailParams(email: emailVO, code: codeVO),
    );

    switch (result) {
      case Success<void>():
        emit(const VerifyEmailSucceeded());
      case FailureResult<void>(failure: final failure):
        emit(VerifyEmailFailed(failure.message));
    }
  }

  Future<void> resendCode({required String email}) async {
    emit(const VerifyEmailLoading());

    final emailVO = Email(email);
    final emailError = emailVO.validate();

    if (emailError != null) {
      emit(CodeResentFailed(emailError));
      return;
    }

    final result = await _resendCodeUseCase(
      ResendCodeParams(email: emailVO),
    );

    switch (result) {
      case Success<void>():
        emit(const CodeResentSucceeded());
      case FailureResult<void>(failure: final failure):
        emit(CodeResentFailed(failure.message));
    }
  }
}
