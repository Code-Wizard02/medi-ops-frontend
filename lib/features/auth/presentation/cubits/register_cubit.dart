import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/app_result.dart';
import '../../application/use_cases/register.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/full_name.dart';
import '../../domain/value_objects/password.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._register) : super(const RegisterInitial());

  final Register _register;

  Future<void> submit({
    required String email,
    required String fullName,
    required String password,
    required String privacyVersion,
  }) async {
    emit(const RegisterLoading());

    final emailVo = Email(email);
    final fullNameVo = FullName(fullName);
    final passwordVo = Password(password);

    if (!emailVo.isValid) {
      emit(RegisterFailed(emailVo.validate()!));
      return;
    }
    if (!fullNameVo.isValid) {
      emit(RegisterFailed(fullNameVo.validate()!));
      return;
    }
    if (!passwordVo.isValid) {
      emit(RegisterFailed(passwordVo.validate()!));
      return;
    }

    final result = await _register(
      RegisterParams(
        email: emailVo,
        fullName: fullNameVo,
        password: passwordVo,
        privacyVersion: privacyVersion,
      ),
    );
    switch (result) {
      case Success<void>():
        emit(const RegisterSucceeded());
      case FailureResult<void>(failure: final failure):
        emit(RegisterFailed(failure.message));
    }
  }
}