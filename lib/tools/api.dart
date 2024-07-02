import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Api {
  static final String env = dotenv.env['ENV'] ?? '';
  static final String host = getHostFromEnv();
  static final String authorizationToken = "bearer 14693d9abb073ba8ed43fc5b0d8633784d3fc733";

  static String getHostFromEnv() {
    if (env == 'dev') {
      return dotenv.env['API_KEY_DEV'] ?? '';
    } else if (env == 'prod') {
      return dotenv.env['API_KEY_PROD'] ?? '';
    }
    return '';
  }

  static Future<http.Response> get(
    String endpoint, {
    Function(http.Response)? onSuccess,
    Function(dynamic)? onError,
  }) async {
    final Uri uri = Uri.parse('$host$endpoint');
    final response = await http.get(
      uri,
      headers: {'Authorization': authorizationToken},
    );

    if (response.statusCode == 200) {
      if (onSuccess != null) {
        onSuccess(response);
      }
    } else {
      if (onError != null) {
        onError(response.body);
      }
    }

    return response;
  }

  static Future<http.Response> post(
    String endpoint,
    dynamic body, {
    Function(http.Response)? onSuccess,
    Function(dynamic)? onError,
  }) async {
    final Uri uri = Uri.parse('$host$endpoint');
    final response = await http.post(uri,
        headers: {'Authorization': authorizationToken}, body: body);

    if (response.statusCode == 200) {
      if (onSuccess != null) {
        onSuccess(response);
      }
    } else {
      if (onError != null) {
        onError(response.body);
      }
    }

    return response;
  }

  static Future<http.Response> put(
    String endpoint,
    dynamic body, {
    Function(http.Response)? onSuccess,
    Function(dynamic)? onError,
  }) async {
    final Uri uri = Uri.parse('$host$endpoint');
    final response = await http.put(uri,
        headers: {'Authorization': authorizationToken}, body: body);

    if (response.statusCode == 200) {
      if (onSuccess != null) {
        onSuccess(response);
      }
    } else {
      if (onError != null) {
        onError(response.body);
      }
    }

    return response;
  }

  static Future<http.Response> delete(
    String endpoint, {
    Function(http.Response)? onSuccess,
    Function(dynamic)? onError,
  }) async {
    final Uri uri = Uri.parse('$host$endpoint');
    final response =
        await http.delete(uri, headers: {'Authorization': authorizationToken});

    if (response.statusCode == 200) {
      if (onSuccess != null) {
        onSuccess(response);
      }
    } else {
      if (onError != null) {
        onError(response.body);
      }
    }

    return response;
  }
}
