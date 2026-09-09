import '../../../../core/result/app_result.dart';
import '../entities/auth_session.dart';
import '../value_objects/email.dart';
import '../value_objects/full_name.dart';
import '../value_objects/password.dart';

abstract interface class AuthRepository {
  Future<AppResult<void>> register({
    required Email email,
    required FullName fullName,
    required Password password,
    required String privacyVersion,
  });

  Future<AppResult<AuthSession>> signIn({
    required Email email,
    required Password password,
  });

  Future<AppResult<AuthSession?>> currentSession();

  Future<AppResult<void>> signOut();
}