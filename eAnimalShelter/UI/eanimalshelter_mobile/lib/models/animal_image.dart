class AnimalImage {
  final int imageId;
  final String imagePath;

  AnimalImage({
    required this.imageId,
    required this.imagePath,
  });

  factory AnimalImage.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnimalImage(
      imageId: json["imageId"],
      imagePath: json["imagePath"] ?? "",
    );
  }
}