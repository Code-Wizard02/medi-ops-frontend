import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class Authenticated extends AuthState {
  const Authenticated(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

final class AuthFailureState extends AuthState {
  const AuthFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class RegistrationSucceeded extends AuthState {
  const RegistrationSucceeded();
}
