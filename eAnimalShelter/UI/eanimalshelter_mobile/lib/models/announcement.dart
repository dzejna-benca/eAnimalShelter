class Announcement {
  final int announcementId;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime publishedDate;
  final bool isActive;

  Announcement({
    required this.announcementId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedDate,
    required this.isActive,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      announcementId: json["announcementId"],
      title: json["title"],
      content: json["content"],
      imageUrl: json["imageUrl"],
      publishedDate:
          DateTime.parse(json["publishedDate"]),
      isActive: json["isActive"],
    );
  }
}