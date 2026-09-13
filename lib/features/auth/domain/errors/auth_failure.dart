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

final class AccountSuspendedFailure extends AuthFailure {
  const AccountSuspendedFailure() : super('account_suspended');
}

final class AccountNotVerifiedFailure extends AuthFailure {
  const AccountNotVerifiedFailure(this.email) : super('account_not_verified');

  final String email;

  @override
  List<Object?> get props => [message, email];
}

final class ServerFailure extends AuthFailure {
  const ServerFailure() : super('server_error');
}