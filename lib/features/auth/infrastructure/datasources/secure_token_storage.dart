import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';

class SecureTokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyIdToken = 'id_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyTokenType = 'token_type';
  static const _keyExpiresAt = 'expires_at';
  
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUserStatus = 'user_status';
  static const _keyUserFullName = 'user_full_name';

  Future<void> saveSession(AuthSession session) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: session.accessToken),
      _storage.write(key: _keyIdToken, value: session.idToken),
      _storage.write(key: _keyRefreshToken, value: session.refreshToken),
      _storage.write(key: _keyTokenType, value: session.tokenType),
      _storage.write(key: _keyExpiresAt, value: session.expiresAt.toIso8601String()),
      _storage.write(key: _keyUserId, value: session.user.id),
      _storage.write(key: _keyUserEmail, value: session.user.email),
      _storage.write(key: _keyUserStatus, value: session.user.status),
      _storage.write(key: _keyUserFullName, value: session.user.displayName ?? ''),
    ]);
  }

  Future<AuthSession?> loadSession() async {
    final accessToken = await _storage.read(key: _keyAccessToken);
    final idToken = await _storage.read(key: _keyIdToken);
    final refreshToken = await _storage.read(key: _keyRefreshToken);
    final tokenType = await _storage.read(key: _keyTokenType);
    final expiresAtStr = await _storage.read(key: _keyExpiresAt);
    
    final userId = await _storage.read(key: _keyUserId);
    final userEmail = await _storage.read(key: _keyUserEmail);
    final userStatus = await _storage.read(key: _keyUserStatus);
    final userFullName = await _storage.read(key: _keyUserFullName);

    if (accessToken == null ||
        idToken == null ||
        refreshToken == null ||
        tokenType == null ||
        expiresAtStr == null ||
        userId == null ||
        userEmail == null ||
        userStatus == null) {
      return null;
    }

    final expiresAt = DateTime.tryParse(expiresAtStr);
    if (expiresAt == null) return null;

    final user = User(
      id: userId,
      email: userEmail,
      status: userStatus,
      displayName: userFullName?.isEmpty == true ? null : userFullName,
    );

    return AuthSession(
      user: user,
      accessToken: accessToken,
      idToken: idToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresAt: expiresAt,
    );
  }

  Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
