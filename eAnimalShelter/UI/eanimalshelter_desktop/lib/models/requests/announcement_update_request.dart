class AnnouncementUpdateRequest {
  String title;
  String content;
  String? imageUrl;
  bool isActive;

  AnnouncementUpdateRequest({
    required this.title,
    required this.content,
    this.imageUrl,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "content": content,
      "imageUrl": imageUrl,
      "isActive": isActive,
    };
  }
}