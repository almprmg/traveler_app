import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:traveler_app/data/api/api_checker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/data/local/local_storage_service.dart';
import 'package:traveler_app/util/app_logger.dart';

class ApiClient extends GetxService {
  final LocalStorageService localStorageService;

  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  static const String serverErrorMessage = 'Server error, contact support.';

  /// Timeout for regular API requests (GET, POST, PUT, DELETE)
  static const int requestTimeoutSeconds = 9999;

  /// Timeout for file uploads (longer due to potential large files)
  static const int uploadTimeoutSeconds = 9999;

  String? token;

  ApiClient({required this.localStorageService}) {
    token = localStorageService.getToken();
    AppLogger.debug('Header: $token');
  }

  bool _isServerError(int statusCode) {
    return statusCode == 500 || statusCode == 501 || statusCode == 502;
  }

  http.Response _getServerErrorResponse(int statusCode) {
    final errorResponse = {
      'success': false,
      'message': {
        'en': serverErrorMessage,
        'ar': 'خطأ في الخادم، اتصل بالدعم.',
      },
      'data': {},
    };
    final jsonString = json.encode(errorResponse);
    return http.Response.bytes(
      utf8.encode(jsonString),
      statusCode,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }

  Map<String, String> _getHeaders({bool includeContentType = true}) {
    final headers = <String, String>{};

    if (includeContentType) {
      headers['Content-Type'] = 'application/json';
    }

    final token = localStorageService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final customerId = localStorageService.getCustomerId();
    if (customerId != null) {
      headers['customer-id'] = customerId;
    }

    final cityId = localStorageService.getCityId();
    if (cityId != null) {
      headers['city-id'] = cityId;
    }

    headers['appversion'] = AppConstants.appVersion.toString();

    headers['devicetype'] = kIsWeb
        ? 'customer_app_web'
        : Platform.isAndroid
        ? 'customer_app_android'
        : 'customer_app_ios';

    return headers;
  }

  Future<http.Response> getData(
    String uri, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        AppLogger.network('====> API Call:$uri\nToken: $token \n');
      }

      final response = await http
          .get(Uri.parse(uri), headers: headers ?? _getHeaders())
          .timeout(const Duration(seconds: requestTimeoutSeconds));

      if (kDebugMode) {
        AppLogger.network(
          '====> API Response: [${response.statusCode}] $uri\n${response.body} \n customer-id: ${localStorageService.getCustomerId()}',
        );
      }

      if (_isServerError(response.statusCode)) {
        return _getServerErrorResponse(response.statusCode);
      }

      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('$e');
      }
      return http.Response('{"message": "$noInternetMessage"}', 503);
    }
  }

  Future<http.Response> postData(
    String uri,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        AppLogger.network('====> API Call: $uri\nToken: $token');
        AppLogger.debug('====> API Body: $body');
        AppLogger.debug('====> API Body Json: ${json.encode(body)}');
      }

      final response = await http
          .post(
            Uri.parse(uri),
            body: json.encode(body),
            headers: headers ?? _getHeaders(),
          )
          .timeout(const Duration(seconds: requestTimeoutSeconds));

      if (kDebugMode) {
        AppLogger.network(
          '====> API Response: [${response.statusCode}] $uri\n${response.body} ',
        );
      }

      if (_isServerError(response.statusCode)) {
        return _getServerErrorResponse(response.statusCode);
      }

      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('$e');
      }
      return http.Response('{"message": "$noInternetMessage"}', 503);
    }
  }

  Future<http.Response> deleteData(
    String uri,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        AppLogger.network('====> API Call: $uri\nToken: $token');
        AppLogger.debug('====> API Body: $body');
        AppLogger.debug('====> API Body Json: ${json.encode(body)}');
      }

      final response = await http
          .delete(
            Uri.parse(uri),
            body: body != null ? json.encode(body) : null,
            headers: headers ?? _getHeaders(),
          )
          .timeout(const Duration(seconds: requestTimeoutSeconds));

      if (kDebugMode) {
        AppLogger.network(
          '====> API Response: [${response.statusCode}] $uri\n${response.body}',
        );
      }

      if (_isServerError(response.statusCode)) {
        return _getServerErrorResponse(response.statusCode);
      }

      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('$e');
      }
      return http.Response('{"message": "$noInternetMessage"}', 503);
    }
  }

  Future<http.Response> putData(
    String uri,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        AppLogger.network('====> API Call: $uri\nToken: $token');
        AppLogger.debug('====> API Body: $body');
        AppLogger.debug('====> API Body Json: ${json.encode(body)}');
      }

      final response = await http
          .put(
            Uri.parse(uri),
            body: json.encode(body),
            headers: _getHeaders()..addAll(headers ?? {}),
          )
          .timeout(const Duration(seconds: requestTimeoutSeconds));

      if (kDebugMode) {
        AppLogger.network(
          '====> API Response: [${response.statusCode}] $uri\n${response.body}',
        );
      }

      if (_isServerError(response.statusCode)) {
        return _getServerErrorResponse(response.statusCode);
      }

      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('$e');
      }
      return http.Response('{"message": "$noInternetMessage"}', 503);
    }
  }

  Future<http.Response> uploadFile(
    String uri,
    File file, {
    String fieldName = 'file',
    Map<String, String>? additionalFields,
    String? fileName,
  }) async {
    try {
      if (kDebugMode) {
        AppLogger.network('====> File Upload API Call: $uri\nToken: $token');
        AppLogger.debug('====> File Path: ${file.path}');
        AppLogger.debug('====> Field Name: $fieldName');
      }

      final request = http.MultipartRequest('POST', Uri.parse(uri));

      request.headers.addAll(_getHeaders(includeContentType: false));

      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          filename: fileName ?? file.path.split('/').last,
        ),
      );

      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
        if (kDebugMode) {
          AppLogger.debug('====> Additional Fields: $additionalFields');
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: uploadTimeoutSeconds),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        AppLogger.network(
          '====> File Upload Response: [${response.statusCode}] $uri\n${response.body}',
        );
      }

      if (_isServerError(response.statusCode)) {
        return _getServerErrorResponse(response.statusCode);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('====> File Upload Error: $e');
      }
      return http.Response('{"message": "$noInternetMessage"}', 503);
    }
  }

  Future<http.Response> uploadBytes(
    String uri,
    Uint8List fileData,
    String fileName, {
    String fieldName = 'file',
    Map<String, String>? additionalFields,
    bool isImage = true,
  }) async {
    try {
      if (kDebugMode) {
        AppLogger.network('====> In-Memory Bytes Upload API Call: $uri');
        AppLogger.debug('====> Token: $token');
        AppLogger.debug('====> Data Size: ${fileData.length} bytes');
        AppLogger.debug('====> Field Name: $fieldName');
        AppLogger.debug('====> File Name: $fileName');
      }

      final request = http.MultipartRequest('POST', Uri.parse(uri));

      request.headers.addAll(_getHeaders(includeContentType: false));

      final contentType = isImage
          ? MediaType('image', path.extension(fileName).replaceAll('.', ''))
          : MediaType('application', 'octet-stream');

      request.files.add(
        http.MultipartFile.fromBytes(
          fieldName,
          fileData,
          filename: fileName,
          contentType: contentType,
        ),
      );

      request.fields['name'] = fileName;
      request.fields['path'] = additionalFields?['path'] ?? 'img';

      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
        if (kDebugMode) {
          AppLogger.debug('====> Additional Fields: $additionalFields');
        }
      }

      if (kDebugMode) {
        AppLogger.debug('====> Request Headers: ${request.headers}');
        AppLogger.debug('====> Request Fields: ${request.fields}');
        AppLogger.debug(
          '====> Processing upload completely in memory - no local storage',
        );
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: uploadTimeoutSeconds),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        AppLogger.network(
          '====> In-Memory Upload Response: [${response.statusCode}] $uri',
        );
        AppLogger.debug('====> Response Body: ${response.body}');
      }

      if (_isServerError(response.statusCode)) {
        return _getServerErrorResponse(response.statusCode);
      }

      if (response.statusCode != 200) {
        ApiChecker.checkApi(response);
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.error('====> In-Memory Upload Error: $e');
      }
      return http.Response('{"message": "$noInternetMessage"}', 503);
    }
  }
}
