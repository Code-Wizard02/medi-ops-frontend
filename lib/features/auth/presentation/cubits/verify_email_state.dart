import 'package:equatable/equatable.dart';

sealed class VerifyEmailState extends Equatable {
  const VerifyEmailState();

  @override
  List<Object?> get props => [];
}

final class VerifyEmailInitial extends VerifyEmailState {
  const VerifyEmailInitial();
}

final class VerifyEmailLoading extends VerifyEmailState {
  const VerifyEmailLoading();
}

final class VerifyEmailSucceeded extends VerifyEmailState {
  const VerifyEmailSucceeded();
}

final class VerifyEmailFailed extends VerifyEmailState {
  const VerifyEmailFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class CodeResentSucceeded extends VerifyEmailState {
  const CodeResentSucceeded();
}

final class CodeResentFailed extends VerifyEmailState {
  const CodeResentFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
