class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://localhost:5036",
  );

  static String get apiUrl => "$baseUrl/";
}