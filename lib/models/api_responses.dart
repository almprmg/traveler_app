import 'package:get/get.dart';
import 'package:traveler_app/controllers/localization_controller.dart';

class ApiResponse<T> {
  final bool success;
  final Message message;
  final T data;
  final int? count;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    this.count,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) dataFromJson,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      // Handle message properly - it might not exist in the response
      message: json['message'] != null
          ? Message.fromJson(json['message'])
          : Message(en: '', ar: ''), // Default empty message
      data: dataFromJson(json['data']),
      count: json['count'] != null ? json['count'] as int : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) dataToJson) {
    return {
      'success': success,
      'message': message.toJson(),
      'data': dataToJson(data),
      'count': count,
    };
  }
}

class Message {
  final String en;
  final String ar;

  Message({required this.en, required this.ar});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(en: json['en'] ?? '', ar: json['ar'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'en': en, 'ar': ar};
  }

  String get getName {
    final isLtr = Get.find<LocalizationController>().isLtr;
    return isLtr ? en : ar;
  }
}
