class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? phoneNumber;
  String? address;
  bool? isActive;
  String? role;
  int? roleId;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.phoneNumber,
    this.address,
    this.isActive,
    this.role,
    this.roleId,
  });

  factory User.fromJson(
    Map<String, dynamic> json,
  ) {
    return User(
      userId: json["userId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      username: json["username"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      isActive: json["isActive"],
      role: json["role"],
      roleId: json["roleId"],
    );
  }
}