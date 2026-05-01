import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/models/api_responses.dart';

class ApiHandler {
  /// Handles the API request flow including 503 checks, JSON decoding, and error handling.
  ///
  /// [request] is a function that returns the API call future (http.Response).
  /// [parser] is a function that parses the 'data' field of the JSON response.
  /// [jsonParser] is an alternative parser that receives the full JSON map (useful when data depends on other fields).
  /// [defaultData] is the value to return in case of error (e.g., empty list or null).
  /// [errorMessageEn] is the custom error message in English.
  /// [errorMessageAr] is the custom error message in Arabic (optional).
  static Future<ApiResponse<T>> handleRequest<T>({
    required Future<http.Response> Function() request,
    T Function(dynamic)? parser,
    T Function(Map<String, dynamic>)? jsonParser,
    required T defaultData,
    String errorMessageEn = 'An error occurred',
    String? errorMessageAr,
  }) async {
    assert(
      parser != null || jsonParser != null,
      'Either parser or jsonParser must be provided',
    );

    try {
      final response = await request();

      // Check for 503 Service Unavailable (often used for custom No Internet in this app)
      if (response.statusCode == 503) {
        if (_isNoInternet(response.body)) {
          return _noInternetResponse<T>(defaultData);
        }
      }

      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Handle server-side errors where success is false
      if (jsonData['success'] == false) {
        Message message;
        if (jsonData['message'] is Map) {
          message = Message.fromJson(jsonData['message']);
        } else if (jsonData['message'] is String) {
          message = Message(en: jsonData['message'], ar: jsonData['message']);
        } else {
          message = Message(
            en: errorMessageEn,
            ar: errorMessageAr ?? errorMessageEn,
          );
        }

        T parsedData = defaultData;
        try {
          if (jsonParser != null) {
            parsedData = jsonParser(jsonData);
          } else if (parser != null && jsonData['data'] != null) {
            parsedData = parser(jsonData['data']);
          }
        } catch (_) {}

        return ApiResponse<T>(
          success: false,
          message: message,
          data: parsedData,
          count: jsonData['count'] is int ? jsonData['count'] : null,
        );
      }

      if (jsonParser != null) {
        return ApiResponse<T>(
          success: jsonData['success'] ?? false,
          message: jsonData['message'] != null
              ? Message.fromJson(jsonData['message'])
              : Message(en: '', ar: ''),
          data: jsonParser(jsonData),
          count: jsonData['count'] != null ? jsonData['count'] as int : null,
        );
      }

      // We rely on ApiResponse.fromJson to handle success/failure flag from JSON
      return ApiResponse<T>.fromJson(jsonData, parser!);
    } on SocketException {
      return _noInternetResponse<T>(defaultData);
    } catch (e) {
      if (kDebugMode) {
        print('API Error [$errorMessageEn]: $e');
      }
      return ApiResponse<T>(
        success: false,
        message: Message(
          en: '$errorMessageEn: ${e.toString()}',
          ar: '${errorMessageAr ?? errorMessageEn}: ${e.toString()}',
        ),
        data: defaultData,
      );
    }
  }

  static bool _isNoInternet(String body) {
    try {
      final Map<String, dynamic> errorData = json.decode(body);
      final String errorMessage = errorData['message'] ?? '';
      return errorMessage == ApiClient.noInternetMessage;
    } catch (e) {
      return false;
    }
  }

  static ApiResponse<T> _noInternetResponse<T>(T defaultData) {
    return ApiResponse<T>(
      success: false,
      message: Message(
        en: 'No internet connection. Please check your network and try again.',
        ar: 'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك والمحاولة مرة أخرى.',
      ),
      data: defaultData,
    );
  }
}
