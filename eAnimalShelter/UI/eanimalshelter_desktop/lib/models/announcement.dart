class Announcement {
  int announcementId;
  String title;
  String content;
  String? imageUrl;
  DateTime? publishedDate;
  bool isActive;
  int createdBy;
  String? createdByUserName;

  Announcement({
    required this.announcementId,
    required this.title,
    required this.content,
    this.imageUrl,
    this.publishedDate,
    required this.isActive,
    required this.createdBy,
    this.createdByUserName,
  });

  factory Announcement.fromJson(
    Map<String, dynamic> json,
  ) {
    return Announcement(
      announcementId:
          json["announcementId"],
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      imageUrl: json["imageUrl"],
      publishedDate:
          json["publishedDate"] != null
              ? DateTime.parse(
                  json["publishedDate"])
              : null,
      isActive:
          json["isActive"] ?? true,
      createdBy:
          json["createdBy"] ?? 0,
      createdByUserName:
          json["createdByUserName"],
    );
  }
}