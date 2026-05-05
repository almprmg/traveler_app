import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:traveler_app/data/api/api_client.dart';
import 'package:traveler_app/util/app_constants.dart';

class DevicesService extends GetxService {
  final ApiClient apiClient;
  DevicesService({required this.apiClient});

  static String _platform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'web';
  }

  /// Register or upsert this device's FCM token.
  Future<bool> registerDevice({
    required String fcmToken,
    String? deviceId,
    String? appVersion,
    String? locale,
  }) async {
    final body = <String, dynamic>{
      'fcm_token': fcmToken,
      'platform': _platform(),
    };
    if (deviceId != null) body['device_id'] = deviceId;
    if (appVersion != null) body['app_version'] = appVersion;
    if (locale != null) body['locale'] = locale;

    final response = await apiClient.postData(
      '${AppConstants.apiUrl}account/devices',
      body,
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> unregisterDevice({required String fcmToken}) async {
    final response = await apiClient.deleteData(
      '${AppConstants.apiUrl}account/devices',
      {'fcm_token': fcmToken},
    );
    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> listDevices() async {
    final response =
        await apiClient.getData('${AppConstants.apiUrl}account/devices');
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['data'];
      List? raw;
      if (data is Map && data['items'] is List) raw = data['items'] as List;
      if (data is List) raw = data;
      return (raw ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList();
    }
    return [];
  }
}
