class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String username;
  String password;
  String? phoneNumber;
  String address;
  int roleId;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    this.phoneNumber,
    required this.address,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "username": username,
      "password": password,
      "phoneNumber": phoneNumber,
      "address": address,
      "roleId": roleId,
      "isActive": true,
    };
  }
}