import 'package:equatable/equatable.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

final class RegisterSucceeded extends RegisterState {
  const RegisterSucceeded();
}

final class RegisterFailed extends RegisterState {
  const RegisterFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
