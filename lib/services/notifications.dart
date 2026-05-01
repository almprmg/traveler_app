import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:traveler_app/util/app_logger.dart';
import 'package:permission_handler/permission_handler.dart';

import 'local_notification_helper.dart';
import 'notification_navigation.dart';

/// Main notification service - coordinates FCM and local notifications.
///
/// Split into:
/// - [NotificationService] - FCM setup, token management, message handling (this file)
/// - [LocalNotificationHelper] - Local notification display and channels
/// - [NotificationNavigation] - Navigation routing and data parsing
class NotificationService {
  NotificationService._();

  static FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  static final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  static Stream<RemoteMessage> get onMessage => _messageStreamController.stream;

  // ============ Public API ============

  /// Check if there's a pending notification navigation
  static bool get hasPendingNavigation =>
      NotificationNavigation.hasPendingNavigation;

  /// Process any pending navigation (call when home page is ready)
  static void processPendingNavigation() =>
      NotificationNavigation.processPendingNavigation();

  /// Clear pending navigation
  static void clearPendingNavigation() =>
      NotificationNavigation.clearPendingNavigation();

  /// Initialize the notification service
  static Future<void> initialize() async {
    await requestPermissions();
    await LocalNotificationHelper.initialize();
    await _setupFCM();

    final token = await getToken();
    AppLogger.network('FCM Token: $token');
  }

  /// Request notification permissions
  static Future<void> requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      announcement: false,
    );

    AppLogger.info('FCM Permission status: ${settings.authorizationStatus}');

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      AppLogger.info('Android Notification Permission: $status');

      if (status.isDenied) {
        AppLogger.warning('Notification permission denied');
      }
    }
  }

  /// Get FCM token
  static Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      AppLogger.error('Error getting FCM token: $e');
      return null;
    }
  }

  /// Listen for token refresh
  static void onTokenRefresh(void Function(String) callback) {
    _messaging.onTokenRefresh.listen(callback);
  }

  /// Delete FCM token
  static Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      AppLogger.info('FCM token deleted');
    } catch (e) {
      AppLogger.error('Error deleting FCM token: $e');
    }
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      AppLogger.info('Subscribed to topic: $topic');
    } catch (e) {
      AppLogger.error('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      AppLogger.info('Unsubscribed from topic: $topic');
    } catch (e) {
      AppLogger.error('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Show a local notification
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
    bool isNewOrder = false,
  }) async {
    await LocalNotificationHelper.show(
      title: title,
      body: body,
      payload: payload,
      isNewOrder: isNewOrder,
    );
  }

  /// Show a test notification
  static Future<void> showTestNotification() async {
    await LocalNotificationHelper.showTest();
  }

  /// Get pending notifications
  static Future<List<dynamic>> getPendingNotifications() {
    return LocalNotificationHelper.getPendingNotifications();
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await LocalNotificationHelper.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await LocalNotificationHelper.cancelAll();
  }

  /// Get notification status
  static Future<Map<String, bool>> getNotificationStatus() async {
    final systemEnabled =
        await LocalNotificationHelper.areNotificationsEnabled();

    bool appEnabled = true;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.status;
      appEnabled = status.isGranted;
    }

    return {'systemEnabled': systemEnabled, 'appEnabled': appEnabled};
  }

  // ============ FCM Setup ============

  static Future<void> _setupFCM() async {
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialNotification(initialMessage);
    }
  }

  // ============ Message Handlers ============

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    AppLogger.network('Background message: ${message.messageId}');
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    AppLogger.network('Foreground message: ${message.messageId}');

    try {
      final data = message.data;
      final type = data['type']?.toString() ?? '';

      if (kDebugMode) {
        AppLogger.debug('=== Foreground Message Received ===');
        AppLogger.debug('Message Type: $type');
        AppLogger.debug('Full message data: $data');
      }

      _messageStreamController.add(message);
      _showNotificationFromMessage(message);
    } catch (e) {
      AppLogger.error('Error processing foreground message: $e');
      _showNotificationFromMessage(message);
    }
  }

  static void _showNotificationFromMessage(RemoteMessage message) {
    final title =
        message.notification?.title ??
        message.data['title']?.toString() ??
        'notification_default_title'.tr;

    final body =
        message.notification?.body ??
        message.data['body']?.toString() ??
        'notification_default_body'.tr;

    final type = message.data['type']?.toString() ?? '';
    final isNewOrder = type == 'NewOrder';

    final additionalData = {
      'type': type,
      'chatRoomId': NotificationNavigation.extractChatRoomId(message.data),
      'orderId': NotificationNavigation.extractOrderId(message.data),
      'messageId': message.messageId ?? '',
    };

    showLocalNotification(
      title: title,
      body: body,
      payload: jsonEncode(additionalData),
      isNewOrder: isNewOrder,
    );
  }

  static void _handleNotificationTap(RemoteMessage message) {
    AppLogger.debug('=== Notification tapped (background/terminated) ===');
    AppLogger.debug('Message ID: ${message.messageId}');

    NotificationNavigation.handleNotificationNavigation(message.data);
  }

  static void _handleInitialNotification(RemoteMessage message) {
    AppLogger.debug('=== Initial notification processing ===');
    AppLogger.debug('Message ID: ${message.messageId}');

    NotificationNavigation.storeInitialNavigation(message.data);
  }
}

/// Top-level function required for FCM background message handling.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.network('Background message: ${message.messageId}');
}
