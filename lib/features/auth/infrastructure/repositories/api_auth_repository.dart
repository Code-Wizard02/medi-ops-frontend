import 'package:dio/dio.dart';

import '../../../../core/result/app_result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import '../datasources/secure_token_storage.dart';

class ApiAuthRepository implements AuthRepository {
  const ApiAuthRepository({
    required Dio client,
    required SecureTokenStorage storage,
  })  : _client = client,
        _storage = storage;

  final Dio _client;
  final SecureTokenStorage _storage;

  @override
  Future<AppResult<AuthSession>> signIn({
    required Email email,
    required Password password,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        'auth/login',
        data: {
          'email': email.value,
          'password': password.value,
        },
      );

      final data = response.data;
      if (data == null) {
        return const FailureResult(ServerFailure());
      }

      final userData = data['user'] as Map<String, dynamic>;
      final user = User(
        id: userData['userId'] as String,
        email: userData['email'] as String,
        status: userData['status'] as String,
        displayName: userData['fullName'] as String?,
      );

      final expiresIn = data['expiresIn'] as int;
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

      final session = AuthSession(
        user: user,
        accessToken: data['accessToken'] as String,
        idToken: data['idToken'] as String,
        refreshToken: data['refreshToken'] as String,
        tokenType: data['tokenType'] as String? ?? 'Bearer',
        expiresAt: expiresAt,
      );

      await _storage.saveSession(session);

      return Success(session);
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final data = e.response!.data;

        if (statusCode == 401) {
          return const FailureResult(InvalidCredentialsFailure());
        } else if (statusCode == 403) {
          return const FailureResult(AccountSuspendedFailure());
        } else if (statusCode == 409) {
          return FailureResult(AccountNotVerifiedFailure(email.value));
        } else if (statusCode == 400 && data is Map<String, dynamic>) {
          String errorMessage = '';

          final invalidParams = data['invalid_params'];
          if (invalidParams is List && invalidParams.isNotEmpty) {
            final reasons = invalidParams
                .whereType<Map<String, dynamic>>()
                .map((param) => param['reason'])
                .whereType<String>();
            if (reasons.isNotEmpty) {
              errorMessage = reasons.join('\n');
            }
          }

          if (errorMessage.isEmpty) {
            final detail = data['detail'] ?? data['title'];
            if (detail is String && detail.isNotEmpty) {
              errorMessage = detail;
            }
          }

          if (errorMessage.isNotEmpty) {
            return FailureResult(RegistrationFailure(errorMessage));
          }
        }
      }
      return const FailureResult(ServerFailure());
    } catch (_) {
      return const FailureResult(ServerFailure());
    }
  }

  @override
  Future<AppResult<AuthSession?>> currentSession() async {
    try {
      final session = await _storage.loadSession();
      return Success(session);
    } catch (_) {
      return const Success(null);
    }
  }

  @override
  Future<AppResult<void>> signOut() async {
    try {
      await _storage.clearSession();
      return const Success(null);
    } catch (_) {
      return const FailureResult(ServerFailure());
    }
  }
}