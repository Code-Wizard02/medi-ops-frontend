class AppConfig {
  static const String _apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_apiBaseUrl.isEmpty) {
      throw Exception(
        'CRÍTICO: La variable de entorno API_BASE_URL no fue inyectada. '
        'Asegúrate de compilar con --dart-define=API_BASE_URL=... o configurar el pipeline en Amplify.',
      );
    }
    return _apiBaseUrl;
  }
}