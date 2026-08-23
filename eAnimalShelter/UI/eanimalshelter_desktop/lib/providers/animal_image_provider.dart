import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../models/animal_image.dart';
import 'auth_provider.dart';
import 'base_provider.dart';

class AnimalImageProvider
    extends BaseProvider<AnimalImage> {

  AnimalImageProvider()
      : super("AnimalImage");

  Future<void> uploadImage(
    int animalId,
    File image,
  ) async {

    var request =
        http.MultipartRequest(
      "POST",
      Uri.parse(
        "${BaseProvider.baseUrl}AnimalImage/upload",
      ),
    );

    request.headers["Authorization"] =
        "Bearer ${AuthProvider.accessToken}";

    request.fields["AnimalId"] =
        animalId.toString();

    final mimeType = lookupMimeType(image.path);

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        image.path,
        contentType: mimeType != null
            ? MediaType.parse(mimeType)
            : MediaType("image", "jpeg"),
      ),
    );

    var response =
        await request.send();

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {

      final body =
          await response.stream.bytesToString();

      throw Exception(
        "Upload failed (${response.statusCode})\n$body",
      );
    }
  }

  @override
  AnimalImage fromJson(data) {
    return AnimalImage.fromJson(data);
  }
}