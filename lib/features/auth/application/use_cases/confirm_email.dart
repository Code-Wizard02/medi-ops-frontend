import '../../../../core/result/app_result.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/repositories/register_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/verification_code.dart';

class ConfirmEmailParams {
  const ConfirmEmailParams({
    required this.email,
    required this.code,
  });

  final Email email;
  final VerificationCode code;
}

class ConfirmEmail implements UseCase<AppResult<void>, ConfirmEmailParams> {
  const ConfirmEmail(this._repository);

  final RegisterRepository _repository;

  @override
  Future<AppResult<void>> call(ConfirmEmailParams params) {
    return _repository.confirmEmail(
      email: params.email,
      code: params.code,
    );
  }
}
