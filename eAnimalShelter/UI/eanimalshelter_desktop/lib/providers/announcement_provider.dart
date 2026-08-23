import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

import '../models/announcement.dart';
import 'auth_provider.dart';
import 'base_provider.dart';

class AnnouncementProvider
    extends BaseProvider<Announcement> {
  AnnouncementProvider()
      : super("Announcement");

  Future<String> uploadImage(
    File image,
  ) async {
    var request =
        http.MultipartRequest(
      "POST",
      Uri.parse(
        "${BaseProvider.baseUrl}Announcement/upload-image",
      ),
    );

    request.headers["Authorization"] =
        "Bearer ${AuthProvider.accessToken}";

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

    final body =
        await response.stream.bytesToString();

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        "Upload failed (${response.statusCode})\n$body",
      );
    }

    final json =
        jsonDecode(body);

    return json["imageUrl"];
  }

  @override
  Announcement fromJson(data) {
    return Announcement.fromJson(data);
  }
}