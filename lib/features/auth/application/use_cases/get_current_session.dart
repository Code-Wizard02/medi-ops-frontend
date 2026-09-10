import '../../../../core/result/app_result.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class GetCurrentSession implements UseCase<AppResult<AuthSession?>, NoParams> {
  const GetCurrentSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppResult<AuthSession?>> call(NoParams params) =>
      _repository.currentSession();
}
