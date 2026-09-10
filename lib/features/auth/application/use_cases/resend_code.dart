import '../../../../core/result/app_result.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/repositories/register_repository.dart';
import '../../domain/value_objects/email.dart';

class ResendCodeParams {
  const ResendCodeParams({
    required this.email,
  });

  final Email email;
}

class ResendCode implements UseCase<AppResult<void>, ResendCodeParams> {
  const ResendCode(this._repository);

  final RegisterRepository _repository;

  @override
  Future<AppResult<void>> call(ResendCodeParams params) {
    return _repository.resendCode(
      email: params.email,
    );
  }
}
