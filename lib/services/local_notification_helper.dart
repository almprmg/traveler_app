import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:traveler_app/util/app_logger.dart';

import 'notification_navigation.dart';

/// Handles local notification initialization, channels, and display.
class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Get the plugin instance for external use
  static FlutterLocalNotificationsPlugin get plugin => _plugin;

  /// Initialize local notifications
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: DarwinInitializationSettings(),
    );

    final initialized = await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    AppLogger.info('Local notifications initialized: $initialized');

    await _createNotificationChannels();
  }

  static void _onNotificationTapped(NotificationResponse response) {
    AppLogger.debug('=== Local notification tapped ===');
    AppLogger.debug('Payload: ${response.payload}');
    NotificationNavigation.handleLocalNotificationTap(response.payload);
  }

  /// Create notification channels for Android
  static Future<void> _createNotificationChannels() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl == null) return;

    final generalChannel = AndroidNotificationChannel(
      'driver_channel',
      'driver_channel_name'.tr,
      description: 'driver_channel_description'.tr,
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    final newOrderChannel = AndroidNotificationChannel(
      'NewOrder',
      'new_order_channel_name'.tr,
      description: 'new_order_channel_description'.tr,
      importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound(
        'notification_new_order_sound',
      ),
      playSound: true,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );

    await androidImpl.createNotificationChannel(generalChannel);
    await androidImpl.createNotificationChannel(newOrderChannel);

    AppLogger.info(
      'Notification channels created: ${generalChannel.id}, ${newOrderChannel.id}',
    );
  }

  /// Show a local notification
  static Future<void> show({
    required String title,
    required String body,
    String? payload,
    bool isNewOrder = false,
  }) async {
    try {
      AppLogger.debug('Showing notification: $title - $body');
      AppLogger.debug('Payload: $payload, Is New Order: $isNewOrder');

      final channelId = isNewOrder ? 'NewOrder' : 'driver_channel';
      final channelName = isNewOrder
          ? 'new_order_channel_name'.tr
          : 'driver_channel_name'.tr;
      final channelDescription = isNewOrder
          ? 'new_order_channel_description'.tr
          : 'driver_channel_description'.tr;
      final soundFile = isNewOrder
          ? 'notification_new_order_sound'
          : 'notification_sound';

      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundFile),
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(
          body,
          htmlFormatBigText: true,
          contentTitle: title,
          htmlFormatContentTitle: true,
        ),
        ticker: title,
        autoCancel: true,
        category: AndroidNotificationCategory.message,
        visibility: NotificationVisibility.public,
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        sound: isNewOrder
            ? 'notification_new_order_sound.caf'
            : 'notification_sound.caf',
        interruptionLevel: InterruptionLevel.active,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _plugin.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: platformDetails,
        payload: payload,
      );

      AppLogger.success(
        'Notification shown with ID: $notificationId, Channel: $channelId',
      );
    } catch (e) {
      AppLogger.error('Error showing local notification: $e');
    }
  }

  /// Show a test notification
  static Future<void> showTest() async {
    await show(
      title: 'notification_test_title'.tr,
      body: 'notification_test_body'.tr,
      payload: '{"type": "test", "messageId": "test_123"}',
    );
  }

  /// Get all pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() {
    return _plugin.pendingNotificationRequests();
  }

  /// Cancel a specific notification
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      return await androidImpl.areNotificationsEnabled() ?? false;
    }

    return true;
  }
}
