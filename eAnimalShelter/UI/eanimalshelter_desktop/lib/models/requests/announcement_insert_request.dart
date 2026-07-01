class AnnouncementInsertRequest {
  String title;
  String content;
  String? imageUrl;

  AnnouncementInsertRequest({
    required this.title,
    required this.content,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content,
      "imageUrl": imageUrl,
    };
  }
}