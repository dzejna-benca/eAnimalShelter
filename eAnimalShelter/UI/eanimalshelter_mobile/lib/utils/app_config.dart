class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://10.0.2.2:5036",
  );
  static String get apiUrl => "$baseUrl/";
}