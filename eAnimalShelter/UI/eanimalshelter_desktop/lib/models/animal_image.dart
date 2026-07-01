import '../providers/base_provider.dart';

class AnimalImage {
  int imageId;
  String imagePath;

  AnimalImage({
    required this.imageId,
    required this.imagePath,
  });

  String get imageUrl =>
      "${BaseProvider.baseUrl}${imagePath.startsWith("/") ? imagePath.substring(1) : imagePath}";

  factory AnimalImage.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnimalImage(
      imageId: json["imageId"],
      imagePath: json["imagePath"] ?? "",
    );
  }
}