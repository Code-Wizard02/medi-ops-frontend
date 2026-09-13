import 'package:equatable/equatable.dart';

import 'user.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.idToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  final User user;
  final String accessToken;
  final String idToken;
  final String refreshToken;
  final String tokenType;
  final DateTime expiresAt;

  bool isExpiredAt(DateTime now) => now.isAfter(expiresAt);

  @override
  List<Object?> get props => [
        user,
        accessToken,
        idToken,
        refreshToken,
        tokenType,
        expiresAt,
      ];
}