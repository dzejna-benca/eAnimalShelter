enum NotificationType {
  adoption,
  volunteer,
  donation,
  announcement,
  system
}

class NotificationModel {
  int? notificationId;

  int? userId;
  String? userName;

  int? targetRoleId;
  String? targetRoleName;

  String? title;
  String? message;

  int? type;

  bool? isRead;

  DateTime? dateSent;
  DateTime? readAt;

  NotificationModel({
    this.notificationId,
    this.userId,
    this.userName,
    this.targetRoleId,
    this.targetRoleName,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.dateSent,
    this.readAt,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationModel(
      notificationId: json["notificationId"],
      userId: json["userId"],
      userName: json["userName"],
      targetRoleId: json["targetRoleId"],
      targetRoleName: json["targetRoleName"],
      title: json["title"],
      message: json["message"],
      type: json["type"],
      isRead: json["isRead"],
      dateSent: json["dateSent"] != null
          ? DateTime.parse(json["dateSent"])
          : null,
      readAt: json["readAt"] != null
          ? DateTime.parse(json["readAt"])
          : null,
    );
  }
}