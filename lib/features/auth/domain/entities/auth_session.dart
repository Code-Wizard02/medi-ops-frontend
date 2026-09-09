import 'package:equatable/equatable.dart';

import 'user.dart';

class AuthSession extends Equatable {
  const AuthSession({required this.user, required this.expiresAt});

  final User user;
  final DateTime expiresAt;

  bool isExpiredAt(DateTime now) => now.isAfter(expiresAt);

  @override
  List<Object?> get props => [user, expiresAt];
}
