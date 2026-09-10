import '../../../../core/result/app_result.dart';
import '../../../../core/usecases/use_case.dart';
import '../../domain/repositories/auth_repository.dart';

class SignOut implements UseCase<AppResult<void>, NoParams> {
  const SignOut(this._repository);

  final AuthRepository _repository;

  @override
  Future<AppResult<void>> call(NoParams params) => _repository.signOut();
}
