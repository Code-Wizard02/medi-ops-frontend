import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/app_result.dart';
import '../../../../core/usecases/use_case.dart';
import '../../application/use_cases/get_current_session.dart';
import '../../application/use_cases/sign_in.dart';
import '../../application/use_cases/sign_out.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required GetCurrentSession getCurrentSessionUseCase,
    required SignIn signInUseCase,
    required SignOut signOutUseCase,
  }) : _getCurrentSessionUseCase = getCurrentSessionUseCase,
       _signInUseCase = signInUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthInitial());

  final GetCurrentSession _getCurrentSessionUseCase;
  final SignIn _signInUseCase;
  final SignOut _signOutUseCase;

  Future<void> initialize() async {
    emit(const AuthLoading());
    final result = await _getCurrentSessionUseCase(const NoParams());
    switch (result) {
      case Success<AuthSession?>(value: final session?)
          when !session.isExpiredAt(DateTime.now()):
        emit(Authenticated(session));
      case Success<AuthSession?>():
        emit(const Unauthenticated());
      case FailureResult<AuthSession?>(failure: final failure):
        emit(AuthFailureState(failure.message));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());

    final emailVo = Email(email);
    final passwordVo = Password(password);

    if (!emailVo.isValid) {
      emit(AuthFailureState(emailVo.validate()!));
      return;
    }
    if (!passwordVo.isValid) {
      emit(AuthFailureState(passwordVo.validate()!));
      return;
    }

    final result = await _signInUseCase(
      SignInParams(email: emailVo, password: passwordVo),
    );
    switch (result) {
      case Success<AuthSession>(value: final session):
        emit(Authenticated(session));
      case FailureResult<AuthSession>(failure: final failure):
        if (failure is AccountNotVerifiedFailure) {
          emit(AccountNotVerified(failure.email));
        } else {
          emit(AuthFailureState(failure.message));
        }
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _signOutUseCase(const NoParams());
    switch (result) {
      case Success<void>():
        emit(const Unauthenticated());
      case FailureResult<void>(failure: final failure):
        emit(AuthFailureState(failure.message));
    }
  }
}