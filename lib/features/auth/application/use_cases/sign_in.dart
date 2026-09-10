import '../../../../core/result/app_result.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';

class SignInParams {
  const SignInParams({required this.email, required this.password});
  final Email email;
  final Password password;
}

class SignIn implements UseCase<AppResult<AuthSession>, SignInParams> {
  const SignIn(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppResult<AuthSession>> call(SignInParams params) {
    return _repository.signIn(email: params.email, password: params.password);
  }
}