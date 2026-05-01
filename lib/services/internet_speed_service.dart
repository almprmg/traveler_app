import 'dart:io' show HttpClient;

import 'package:traveler_app/util/app_logger.dart';

enum InternetSpeed { slow, medium, fast }

class InternetSpeedService {
  InternetSpeedService._internal();
  static final InternetSpeedService _instance =
      InternetSpeedService._internal();

  factory InternetSpeedService() => _instance;

  InternetSpeed? _speed;

  InternetSpeed get speed => _speed ?? InternetSpeed.medium;

  bool get isInitialized => _speed != null;

  Future<void> init() async {
    if (_speed != null) return;

    try {
      final stopwatch = Stopwatch()..start();

      final request = await HttpClient().getUrl(
        Uri.parse('https://www.google.com/favicon.ico'),
      );
      final response = await request.close();
      await response.drain();

      stopwatch.stop();

      final timeMs = stopwatch.elapsedMilliseconds;
      AppLogger.info('Internet speed: $timeMs ms');
      if (timeMs < 50) {
        _speed = InternetSpeed.fast;
      } else if (timeMs < 300) {
        _speed = InternetSpeed.medium;
      } else {
        _speed = InternetSpeed.slow;
      }
    } catch (_) {
      _speed = InternetSpeed.slow;
    }
  }
}
