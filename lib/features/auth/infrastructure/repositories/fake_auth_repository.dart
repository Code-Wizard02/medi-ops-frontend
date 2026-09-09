import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/result/app_result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/full_name.dart';
import '../../domain/value_objects/password.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({Dio? client})
    : _client =
          client ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              headers: {'Content-Type': 'application/json'},
            ),
          );

  static const demoEmail = 'demo@mediops.com';
  static const demoPassword = 'Mediops123!';

  final Dio _client;
  AuthSession? _session;

  @override
  Future<AppResult<void>> register({
    required Email email,
    required FullName fullName,
    required Password password,
    required String privacyVersion,
  }) async {
    try {
      await _client.post<void>(
        'auth/register',
        data: {
          'email': email.value,
          'full_name': fullName.value,
          'password': password.value,
          'privacy_version': privacyVersion,
        },
      );
      return const Success(null);
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final detail = data['detail'] ?? data['title'];
        if (detail is String && detail.isNotEmpty) {
          return FailureResult(RegistrationFailure(detail));
        }
      }
      return FailureResult(
        RegistrationFailure(
          'No se pudo registrar la cuenta (${error.response?.statusCode ?? 'sin respuesta'}).',
        ),
      );
    }
  }

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
        displayName: 'Usuario demo',
      ),
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