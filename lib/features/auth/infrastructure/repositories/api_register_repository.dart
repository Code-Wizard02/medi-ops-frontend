import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';

import '../../../../core/result/app_result.dart';
import '../../domain/errors/register_failure.dart';
import '../../domain/repositories/register_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/full_name.dart';
import '../../domain/value_objects/password.dart';
import '../../domain/value_objects/verification_code.dart';

class ApiRegisterRepository implements RegisterRepository {
  ApiRegisterRepository({Dio? client})
    : _client =
          client ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              headers: {'Content-Type': 'application/json'},
            ),
          );

  final Dio _client;

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
          return FailureResult(RegisterFailure(errorMessage));
        }
      }
      return FailureResult(
        RegisterFailure(
          'No se pudo registrar la cuenta (${error.response?.statusCode ?? 'sin respuesta'}).',
        ),
      );
    }
  }

  @override
  Future<AppResult<void>> confirmEmail({
    required Email email,
    required VerificationCode code,
  }) async {
    try {
      await _client.post<void>(
        'auth/confirm-email',
        data: {
          'email': email.value,
          'code': code.value,
        },
      );
      return const Success(null);
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final detail = data['detail'] ?? data['title'];
        if (detail is String && detail.isNotEmpty) {
          return FailureResult(RegisterFailure(detail));
        }
      }
      return FailureResult(
        RegisterFailure(
          'Error al verificar el correo (${error.response?.statusCode ?? 'sin respuesta'}).',
        ),
      );
    }
  }

  @override
  Future<AppResult<void>> resendCode({
    required Email email,
  }) async {
    try {
      await _client.post<void>(
        'auth/resend-code',
        data: {
          'email': email.value,
        },
      );
      return const Success(null);
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final detail = data['detail'] ?? data['title'];
        if (detail is String && detail.isNotEmpty) {
          return FailureResult(RegisterFailure(detail));
        }
      }
      return FailureResult(
        RegisterFailure(
          'Error al reenviar el código (${error.response?.statusCode ?? 'sin respuesta'}).',
        ),
      );
    }
  }
}