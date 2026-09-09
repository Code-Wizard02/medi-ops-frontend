import '../../../../core/result/app_result.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/repositories/register_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/full_name.dart';
import '../../domain/value_objects/password.dart';

class RegisterParams {
  const RegisterParams({
    required this.email,
    required this.fullName,
    required this.password,
    required this.privacyVersion,
  });

  final Email email;
  final FullName fullName;
  final Password password;
  final String privacyVersion;
}

class Register implements UseCase<AppResult<void>, RegisterParams> {
  const Register(this._repository);

  final RegisterRepository _repository;

  @override
  Future<AppResult<void>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      fullName: params.fullName,
      password: params.password,
      privacyVersion: params.privacyVersion,
    );
  }
}