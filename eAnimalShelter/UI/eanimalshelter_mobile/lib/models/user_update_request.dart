class ProfileUpdateRequest {
  String firstName;
  String lastName;
  String email;
  String? phoneNumber;
  String? address;

  ProfileUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "address": address,
    };
  }
}