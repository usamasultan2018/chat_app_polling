class ApiConstants {
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 60); // was 15
  static const Duration receiveTimeout = Duration(seconds: 120); // was 20
  static const Duration sendTimeout = Duration(seconds: 60); // was 15

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String authorization = 'Authorization';

  // Shared Preferences Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  static const String statusKey = 'status';
  static const String messageKey = 'message';
  static const String dataKey = 'data';

  // Others
  static const String bearer = 'Bearer ';
}
