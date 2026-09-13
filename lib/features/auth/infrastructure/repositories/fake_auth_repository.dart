import '../../../../core/result/app_result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository();

  static const demoEmail = 'demo@mediops.com';
  static const demoPassword = 'Mediops123!';
  AuthSession? _session;

  @override
  Future<AppResult<AuthSession>> signIn({
    required Email email,
    required Password password,
  }) async {
    if (email.value != demoEmail || password.value != demoPassword) {
      return const FailureResult(InvalidCredentialsFailure());
    }

    final session = AuthSession(
      user: const User(
        id: 'demo-user',
        email: demoEmail,
        status: 'ACTIVE',
        displayName: 'Usuario demo',
      ),
      accessToken: 'fake_access_token',
      idToken: 'fake_id_token',
      refreshToken: 'fake_refresh_token',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
    _session = session;
    return Success(session);
  }

  @override
  Future<AppResult<AuthSession?>> currentSession() async => Success(_session);

  @override
  Future<AppResult<void>> signOut() async {
    _session = null;
    return const Success(null);
  }
}