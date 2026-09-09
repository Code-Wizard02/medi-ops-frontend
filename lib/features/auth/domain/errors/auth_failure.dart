import '../../../../core/errors/failure.dart';

sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('invalid_credentials');
}

final class SessionUnavailableFailure extends AuthFailure {
  const SessionUnavailableFailure() : super('session_unavailable');
}

final class RegistrationFailure extends AuthFailure {
  const RegistrationFailure(super.message);
}
