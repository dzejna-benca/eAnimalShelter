enum NotificationType {
  adoption,
  volunteer,
  donation,
  announcement,
  system,
}

class NotificationModel {
  final int notificationId;
  final int? userId;
  final String? userName;
  final int? targetRoleId;
  final String? targetRoleName;

  final String title;
  final String message;

  final NotificationType type;

  final bool isRead;

  final DateTime dateSent;
  final DateTime? readAt;

  NotificationModel({
    required this.notificationId,
    this.userId,
    this.userName,
    this.targetRoleId,
    this.targetRoleName,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.dateSent,
    this.readAt,
  });

  factory NotificationModel.fromJson(
      Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json["notificationId"],
      userId: json["userId"],
      userName: json["userName"],
      targetRoleId: json["targetRoleId"],
      targetRoleName: json["targetRoleName"],
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      type: NotificationType.values[
          json["type"]],
      isRead: json["isRead"] ?? false,
      dateSent:
          DateTime.parse(json["dateSent"]),
      readAt: json["readAt"] != null
          ? DateTime.parse(json["readAt"])
          : null,
    );
  }
}