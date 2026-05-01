import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/util/app_logger.dart';

class UploadService extends GetxService {
  final ApiClient apiClient;

  UploadService({required this.apiClient});

  /// Upload Uint8List data directly from memory - no local storage
  Future<String?> uploadBytes(
    Uint8List fileData, {
    String fileName = 'image.png',
    String fieldName = 'file',
    Map<String, String>? additionalFields,
    bool isImage = true,
  }) async {
    try {
      AppLogger.network('====> Starting in-memory bytes upload: $fileName');
      AppLogger.network('====> Data size: ${fileData.length} bytes');

      final response = await apiClient.uploadBytes(
        AppConstants.uploadFileUri,
        fileData,
        fileName,
        fieldName: fieldName,
        additionalFields:
            additionalFields ?? {'name': fileName, 'path': 'uploads'},
        isImage: isImage,
      );

      AppLogger.network(
        '====> Bytes Upload Response Status: ${response.statusCode}',
      );
      AppLogger.network('====> Bytes Upload Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract URL based on your working implementation structure
        String? url;
        if (responseData['data'] is Map) {
          url = responseData['data']?['url'];
        } else if (responseData['data'] is String) {
          url = responseData['data'];
        }

        if (url != null) {
          AppLogger.network('====> Bytes uploaded successfully. URL: $url');
          return url;
        } else {
          AppLogger.network(
            '====> Upload successful but no URL found in response',
          );
          AppLogger.network(
            '====> Response data structure: ${responseData['data']}',
          );
          return null;
        }
      } else {
        AppLogger.error(
          '====> Bytes upload failed with status: ${response.statusCode}',
        );
        AppLogger.error('====> Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      AppLogger.error('====> Bytes upload error: $e');
      return null;
    }
  }

  /// Upload QR code from Uint8List - completely in memory
  Future<String?> uploadQrCode(
    Uint8List imageData, {
    String path = 'qrCode',
  }) async {
    if (imageData.isEmpty) {
      return null;
    }

    String fileName = 'qr_code_${DateTime.now().millisecondsSinceEpoch}.png';

    return await uploadBytes(
      imageData,
      fileName: fileName,
      fieldName: 'file',
      additionalFields: {'name': fileName, 'path': path},
      isImage: true,
    );
  }

  /// Upload any image from Uint8List - completely in memory
  Future<String?> uploadImageBytes(
    Uint8List imageData, {
    String? customFileName,
    String path = 'images',
  }) async {
    if (imageData.isEmpty) {
      return null;
    }

    String fileName =
        customFileName ?? 'image_${DateTime.now().millisecondsSinceEpoch}.png';

    return await uploadBytes(
      imageData,
      fileName: fileName,
      fieldName: 'file',
      additionalFields: {'name': fileName, 'path': path},
      isImage: true,
    );
  }

  /// Upload profile photo from Uint8List - completely in memory
  Future<String?> uploadProfilePhotoBytes(Uint8List imageData) async {
    if (imageData.isEmpty) {
      return null;
    }

    String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';

    return await uploadBytes(
      imageData,
      fileName: fileName,
      fieldName: 'file',
      additionalFields: {'name': fileName, 'path': 'profilePhoto'},
      isImage: true,
    );
  }

  /// Upload file from File object (keeping for backward compatibility)
  Future<String?> uploadFile(File file) async {
    try {
      AppLogger.network('====> Starting file upload: ${file.path}');

      // Additional fields to match the TypeScript implementation
      Map<String, String> additionalFields = {
        'name': 'profilePhoto',
        'path': 'profilePhoto',
      };

      // Use the uploadFile method from ApiClient
      final response = await apiClient.uploadFile(
        AppConstants.uploadFileUri,
        file,
        fieldName: 'file',
        additionalFields: additionalFields,
      );

      AppLogger.network('====> Upload Response Status: ${response.statusCode}');
      AppLogger.network('====> Upload Response Body: ${response.body}');

      // Check if the request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the URL from the response data
        final String? url = responseData['data']?['url'];

        if (url != null) {
          AppLogger.network('====> File uploaded successfully. URL: $url');
          return url;
        } else {
          AppLogger.network(
            '====> Upload successful but no URL found in response',
          );
          return null;
        }
      } else {
        AppLogger.error(
          '====> Upload failed with status: ${response.statusCode}',
        );
        AppLogger.error('====> Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      AppLogger.error('====> Upload error: $e');
      return null;
    }
  }

  /// Upload multiple byte arrays - all in memory
  Future<List<String?>> uploadMultipleBytes(
    List<Uint8List> byteArrays, {
    List<String>? fileNames,
    String path = 'uploads',
  }) async {
    List<String?> urls = [];

    for (int i = 0; i < byteArrays.length; i++) {
      String fileName = fileNames != null && i < fileNames.length
          ? fileNames[i]
          : 'file_${DateTime.now().millisecondsSinceEpoch}_$i.png';

      final url = await uploadBytes(
        byteArrays[i],
        fileName: fileName,
        additionalFields: {'name': fileName, 'path': path},
      );
      urls.add(url);
    }

    return urls;
  }
}
