import 'package:equatable/equatable.dart';

import '../errors/failure.dart';

sealed class AppResult<T> extends Equatable {
  const AppResult();
}

final class Success<T> extends AppResult<T> {
  const Success(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

final class FailureResult<T> extends AppResult<T> {
  const FailureResult(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
