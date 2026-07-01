class UserPasswordChangeRequest {
  String password;
  String newPassword;
  String confirmNewPassword;

  UserPasswordChangeRequest({
    required this.password,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "password": password,
      "newPassword": newPassword,
      "confirmNewPassword":
          confirmNewPassword,
    };
  }
}