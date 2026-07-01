import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';
import '../models/search_result.dart';
import 'auth_provider.dart';

abstract class BaseProvider<T> with ChangeNotifier {

  final String endpoint;

  static String get baseUrl => AppConfig.apiUrl;

  BaseProvider(this.endpoint);

  T fromJson(dynamic data);

  Future<SearchResult<T>> get({
    Map<String, dynamic>? filter,
  }) async {
    var url = "$baseUrl$endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);

      if (queryString.isNotEmpty) {
        url = "$url?$queryString";
      }
    }

    var uri = Uri.parse(url);

    var headers = createHeaders();

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      SearchResult<T> result =
          SearchResult<T>();

      result.totalCount =
          data["totalCount"];

      result.items = List<T>.from(
        data["items"].map(
          (x) => fromJson(x),
        ),
      );

      return result;
    }

    throw Exception(
      "Unknown error occurred.",
    );
  }

  Future<T> getById(int id) async {
    var url = "$baseUrl$endpoint/$id";

    var uri = Uri.parse(url);

    var response = await safeGet(uri);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    }

    throw Exception(
      "Unable to load data.",
    );
  }

  Future<T> insert(dynamic request) async {
    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);

    var response = await http.post(
      uri,
      headers: createHeaders(),
      body: jsonEncode(request),
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    }

    var error = jsonDecode(response.body);

    if (error["errors"] is Map) {
      throw Exception(
        error["errors"]
            .values
            .expand((x) => x)
            .join("\n"),
      );
    }

    if (error["errors"] is List) {
      throw Exception(
        (error["errors"] as List)
            .join("\n"),
      );
    }

    throw Exception(
      error["message"] ??
          "Validation error",
    );
  }

  Future<T> update(
    int id,
    dynamic request,
  ) async {
    var url = "$baseUrl$endpoint/$id";

    var uri = Uri.parse(url);

    var response = await http.put(
      uri,
      headers: createHeaders(),
      body: jsonEncode(request),
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    }

    var error = jsonDecode(response.body);

    if (error["errors"] is Map) {
      throw Exception(
        error["errors"]
            .values
            .expand((x) => x)
            .join("\n"),
      );
    }

    if (error["errors"] is List) {
      throw Exception(
        (error["errors"] as List)
            .join("\n"),
      );
    }

    throw Exception(
      error["message"] ??
          "Validation error",
    );

    
  }
  Future<http.Response> safeGet(
  Uri uri,
) async {
  try {
    return await http.get(
      uri,
      headers: createHeaders(),
    );
  } on http.ClientException {
    throw Exception(
      "Unable to connect to server.",
    );
  } catch (e) {
    if (e.toString().contains("SocketException")) {
      throw Exception(
        "Unable to connect to server.",
      );
    }

    rethrow;
  }
}

  Future<void> delete(int id) async {
    var url = "$baseUrl$endpoint/$id";

    var uri = Uri.parse(url);

    var response = await http.delete(
      uri,
      headers: createHeaders(),
    );

    if (!isValidResponse(response)) {
      throw Exception(
        "Delete failed.",
      );
    }
  }

 bool isValidResponse(
  http.Response response,
) {
  if (response.statusCode >= 200 &&
      response.statusCode < 300) {
    return true;
  }

  if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  }

  return false;
}

    

  Map<String, String> createHeaders() {
    String token =
        AuthProvider.accessToken ?? "";

    return {
      "Content-Type":
          "application/json",
      "Authorization":
          "Bearer $token",
    };
  }

  String getQueryString(
    Map params, {
    String prefix = '&',
    bool inRecursion = false,
  }) {
    String query = '';

    params.forEach((key, value) {
      if (value == null) return;

      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else {
          key = '.$key';
        }
      }

      if (value is String ||
          value is int ||
          value is double ||
          value is bool) {
        var encoded = value;

        if (value is String) {
          encoded =
              Uri.encodeComponent(
            value,
          );
        }

        query +=
            '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query +=
            '$prefix$key=${value.toIso8601String()}';
      } else if (value is List ||
          value is Map) {
        if (value is List) {
          value = value.asMap();
        }

        value.forEach((k, v) {
          query += getQueryString(
            {k: v},
            prefix: '$prefix$key',
            inRecursion: true,
          );
        });
      }
    });

    if (query.startsWith('&')) {
      query = query.substring(1);
    }

    return query;
  }
  Future<T> getSingle([String path = ""]) async {
    var url = "$baseUrl$endpoint";

    if (path.isNotEmpty) {
      url += "/$path";
    }

    var response = await safeGet(
  Uri.parse(url),
);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    }

    throw Exception("Unable to load data.");
  }
  Future<T> postCustom(
    String path,
    dynamic request,
  ) async {
    var url = "$baseUrl$endpoint";

    if (path.isNotEmpty) {
      url += "/$path";
    }

    var response = await http.post(
      Uri.parse(url),
      headers: createHeaders(),
      body: jsonEncode(request),
    );

    if (isValidResponse(response)) {
      if (response.body.isEmpty) {
        return fromJson({});
      }

      var data = jsonDecode(response.body);
      return fromJson(data);
    }

    var error = jsonDecode(response.body);

    if (error["errors"] is Map) {
      throw Exception(
        error["errors"]
            .values
            .expand((x) => x)
            .join("\n"),
      );
    }

    throw Exception(
      error["message"] ??
          "An error occurred.",
    );
  }
  Future<T> putCustom(
    String path,
    dynamic request,
  ) async {
    var url = "$baseUrl$endpoint";

    if (path.isNotEmpty) {
      url += "/$path";
    }

    var response = await http.put(
      Uri.parse(url),
      headers: createHeaders(),
      body: jsonEncode(request),
    );

    if (isValidResponse(response)) {
      if (response.body.isEmpty) {
        return fromJson({});
      }

      var data = jsonDecode(response.body);
      return fromJson(data);
    }

    var error = jsonDecode(response.body);

    if (error["errors"] is Map) {
      throw Exception(
        error["errors"]
            .values
            .expand((x) => x)
            .join("\n"),
      );
    }

    if (error["errors"] is List) {
      throw Exception(
        (error["errors"] as List)
            .join("\n"),
      );
    }

    throw Exception(
      error["message"] ??
          "An error occurred.",
    );
  }
  Future<void> putVoid(
  String path,
  dynamic request,
) async {
  var url = "$baseUrl$endpoint";

  if (path.isNotEmpty) {
    url += "/$path";
  }

  var response = await http.put(
    Uri.parse(url),
    headers: createHeaders(),
    body: request == null
        ? null
        : jsonEncode(request),
  );

  if (!isValidResponse(response)) {
    throw Exception("Request failed.");
  }
}
  Future<dynamic> postRaw(
  String path,
  dynamic request,
) async {
  var url = "$baseUrl$endpoint";

  if (path.isNotEmpty) {
    url += "/$path";
  }

  final response = await http.post(
    Uri.parse(url),
    headers: createHeaders(),
    body: jsonEncode(request),
  );

  print("POST $url");
  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode >= 200 &&
      response.statusCode < 300) {
    if (response.body.trim().isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }

  if (response.body.trim().isEmpty) {
    throw Exception(
        "Server returned ${response.statusCode}");
  }

  try {
    final error = jsonDecode(response.body);

    if (error["errors"] is Map) {
      throw Exception(
        error["errors"]
            .values
            .expand((x) => x)
            .join("\n"),
      );
    }

    throw Exception(
      error["message"] ??
          "Server returned ${response.statusCode}",
    );
  } catch (_) {
    throw Exception(
      "Server returned ${response.statusCode}\n${response.body}",
    );
  }
}
Future<List<int>> downloadFile(String path) async {
  var url = "$baseUrl$endpoint";

  if (path.isNotEmpty) {
    url += "/$path";
  }

 var response = await safeGet(
  Uri.parse(url),
);
  if (!isValidResponse(response)) {
    throw Exception("Unable to download file.");
  }

  return response.bodyBytes;
}
Future<List<TItem>> getRawList<TItem>(
  String path,
) async {
  var url = "$baseUrl$endpoint/$path";

  var response = await safeGet(
  Uri.parse(url),
);

  if (isValidResponse(response)) {
    final data = jsonDecode(response.body);

    return List<TItem>.from(data);
  }

  throw Exception(
    "Unable to load data.",
  );
}

Future<void> postVoid(
  String path,
) async {
  var url = "$baseUrl$endpoint/$path";

  final response = await http.post(
    Uri.parse(url),
    headers: createHeaders(),
  );

  if (!isValidResponse(response)) {
    throw Exception(
      "Request failed.",
    );
  }
}
Future<T> getRaw<T>(String path) async {
  var url = "$baseUrl$endpoint/$path";

  var response = await safeGet(
  Uri.parse(url),
);

  if (isValidResponse(response)) {
    return jsonDecode(response.body) as T;
  }

  throw Exception("Unable to load data.");
}
Future<List<T>> getList({
  Map<String, dynamic>? filter,
}) async {
  var url = "$baseUrl$endpoint";

  if (filter != null) {
    var queryString = getQueryString(filter);

    if (queryString.isNotEmpty) {
      url = "$url?$queryString";
    }
  }

  var response = await safeGet(
  Uri.parse(url),
);

  if (isValidResponse(response)) {
    final data = jsonDecode(response.body);

    return List<T>.from(
      data.map((e) => fromJson(e)),
    );
  }

  throw Exception("Unable to load data.");
}
}