class UserSearchObject {
  String? fullName;
  String? role;
  bool? isActive;

  int page;
  int pageSize;

  UserSearchObject({
    this.fullName,
    this.role,
    this.isActive,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "role": role,
      "isActive": isActive,
      "page": page,
      "pageSize": pageSize,
      "includeTotalCount": true,
    };
  }
}