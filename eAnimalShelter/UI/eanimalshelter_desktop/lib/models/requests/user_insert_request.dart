class UserInsertRequest {
  String firstName;
  String lastName;
  String email;
  String username;
  String password;
  String? phoneNumber;
  String address;
  bool isActive;
  int roleId;

  UserInsertRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    this.phoneNumber,
    required this.address,
    required this.roleId,
    this.isActive = true,
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
      "isActive": isActive,
      "roleId": roleId,
    };
  }
}