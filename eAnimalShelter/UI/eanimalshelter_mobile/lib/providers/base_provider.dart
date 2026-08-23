import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/app_config.dart';
import '../utils/navigation_utils.dart';
import '../models/search_result.dart';
import '../screens/auth/login_screen.dart';
import 'auth_provider.dart';

abstract class BaseProvider<T> with ChangeNotifier {

  final String endpoint;
  static bool _isLoggingOut = false;

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

    var response = await sendRequest(
    () => http.get(
      uri,
      headers:createHeaders(),
    ),
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
      extractErrorMessage(response),
    );
  }

  String extractErrorMessage(http.Response response) {
  try {
    final error = jsonDecode(response.body);

    if (error["errors"] is Map) {
      return error["errors"]
          .values
          .expand((x) => x)
          .join("\n");
    }

    if (error["errors"] is List) {
      return (error["errors"] as List).join("\n");
    }

    if (error["message"] != null) {
      return error["message"];
    }

    if (error["title"] != null) {
      return error["title"];
    }

    if (error["detail"] != null) {
      return error["detail"];
    }
  } catch (_) {}

  return "An unexpected error occurred.";
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
      extractErrorMessage(response),
    );
  }
 Future<http.Response> sendRequest(
  Future<http.Response> Function() request,
) async {
  var response = await request();

  // Ako nije 401, vrati odgovor
  if (response.statusCode != 401) {
    return response;
  }

  // Pokušaj refresh tokena
  bool refreshed =
      await AuthProvider.instance!.refreshAccessToken();

  // Refresh nije uspio -> odjavi korisnika
  if (!refreshed) {
    if (!_isLoggingOut) {
      try {
        _isLoggingOut = true;

        await AuthProvider.instance!.logout();

        await NavigationUtils.showSessionExpiredDialog();

        await NavigationUtils.pushAndRemoveAll(
          const LoginScreen(),
        );
      } finally {
        _isLoggingOut = false;
      }
    }

    throw Exception(
      "Session expired, please log in again.",
    );
  }

  // Refresh uspio -> ponovi originalni request
  response = await request();

  // Ako i dalje vraća 401, nešto nije u redu
  if (response.statusCode == 401) {
    if (!_isLoggingOut) {
      try {
        _isLoggingOut = true;

        await AuthProvider.instance!.logout();

        await NavigationUtils.showSessionExpiredDialog();

        await NavigationUtils.pushAndRemoveAll(
          const LoginScreen(),
        );
      } finally {
        _isLoggingOut = false;
      }
    }

    throw Exception("Unauthorized");
  }

  return response;
}

  Future<T> insert(dynamic request) async {
    var url = "$baseUrl$endpoint";

    var uri = Uri.parse(url);

    var response = await sendRequest(
      () => http.post(
        uri,
        headers: createHeaders(),
        body: jsonEncode(request),
      ),
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
      extractErrorMessage(response),
    );
  }

  Future<T> update(
    int id,
    dynamic request,
  ) async {
    var url = "$baseUrl$endpoint/$id";

    var uri = Uri.parse(url);

    var response = await sendRequest(
      () => http.put(
        uri,
        headers: createHeaders(),
        body: jsonEncode(request),
      ),
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
      extractErrorMessage(response),
    );

    
  }
  Future<http.Response> safeGet(
  Uri uri,
) async {
  try {
    return await sendRequest(
    () => http.get(
      uri,
      headers: createHeaders(),
    ),
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

    var response = await sendRequest(
      () => http.delete(
        uri,
        headers: createHeaders(),
      ),
    );

    if (!isValidResponse(response)) {
      throw Exception(
        extractErrorMessage(response),
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

    var response = await sendRequest(
      () => http.post(
        Uri.parse(url),
        headers: createHeaders(),
        body: jsonEncode(request),
      ),
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

    var response = await sendRequest(
      () => http.put(
        Uri.parse(url),
        headers: createHeaders(),
        body: jsonEncode(request),
      ),
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

 var response = await sendRequest(
  () => http.put(
    Uri.parse(url),
    headers: createHeaders(),
    body: request == null
        ? null
        : jsonEncode(request),
  ),
);

  if (!isValidResponse(response)) {
    throw Exception(
      extractErrorMessage(response),
    );
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

  final response = await sendRequest(
    () => http.post(
      Uri.parse(url),
      headers: createHeaders(),
      body: jsonEncode(request),
    ),
  );

  if (response.statusCode >= 200 &&
      response.statusCode < 300) {
    if (response.body.trim().isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }

  if (response.body.trim().isEmpty) {
    throw Exception(
        extractErrorMessage(response));
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
      extractErrorMessage(response)
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
    throw Exception(extractErrorMessage(response));
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

  throw Exception(extractErrorMessage(response));
}

Future<void> postVoid(
  String path,
) async {
  var url = "$baseUrl$endpoint/$path";

 final response = await sendRequest(
    () => http.post(
      Uri.parse(url),
      headers: createHeaders(),
    ),
  );

  if (!isValidResponse(response)) {
    throw Exception(
      extractErrorMessage(response),
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

  throw Exception(extractErrorMessage(response));
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

  throw Exception(extractErrorMessage(response));
}
}