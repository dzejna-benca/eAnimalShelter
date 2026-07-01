class UserUpdateRequest {
  String firstName;
  String lastName;
  String email;
  String? phoneNumber;
  String? address;
  bool isActive;
  int roleId;

  UserUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.address,
    required this.isActive,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "address": address,
      "isActive": isActive,
      "roleId": roleId,
    };
  }
}