enum UserRoleType {
  client,
  volunteer,
}

class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String username;
  String password;
  String? phoneNumber;
  String address;
  UserRoleType role;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    this.phoneNumber,
    required this.address,
    required this.role,
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
      "role": role == UserRoleType.client
          ? 3 : 2,
    };
  }
}