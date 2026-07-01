class LoginResponse {
  String accessToken;
  String refreshToken;
  String role;
  String firstName;
  String lastName;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory LoginResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginResponse(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      role: json["role"],
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }
}