import 'dart:convert';

import 'package:get/get.dart';
import 'package:traveler_app/util/app_logger.dart';

/// Handles notification navigation, data parsing, and pending navigation state.
class NotificationNavigation {
  NotificationNavigation._();

  // Pending navigation state
  static String? _pendingRoute;
  static Map<String, String>? _pendingParameters;

  /// Check if there's a pending notification navigation
  static bool get hasPendingNavigation => _pendingRoute != null;

  /// Process any pending navigation (call when home page is ready)
  static void processPendingNavigation() {
    if (_pendingRoute == null) return;

    AppLogger.navigation('Processing pending navigation: $_pendingRoute');
    try {
      Get.toNamed(_pendingRoute!, parameters: _pendingParameters);
    } catch (e) {
      AppLogger.error('Error processing pending navigation: $e');
    } finally {
      clearPendingNavigation();
    }
  }

  /// Clear pending navigation
  static void clearPendingNavigation() {
    _pendingRoute = null;
    _pendingParameters = null;
  }

  /// Set pending navigation for later processing
  static void setPendingNavigation(
    String route, {
    Map<String, String>? parameters,
  }) {
    _pendingRoute = route;
    _pendingParameters = parameters;
    AppLogger.debug('Pending navigation set: $route');
  }

  /// Safe navigation that handles GetX not being ready
  static Future<void> safeNavigate(
    String route, {
    Map<String, String>? parameters,
  }) async {
    try {
      if (Get.key.currentState != null) {
        AppLogger.navigation('GetX ready - navigating to: $route');
        Get.toNamed(route, parameters: parameters);
      } else {
        AppLogger.debug('GetX not ready - queuing navigation to: $route');
        setPendingNavigation(route, parameters: parameters);
      }
    } catch (e) {
      AppLogger.error('Error in safe navigate: $e');
      setPendingNavigation(route, parameters: parameters);
    }
  }

  /// Handle navigation based on notification data
  static Future<void> handleNotificationNavigation(
    Map<String, dynamic> data,
  ) async {
    final type = data['type']?.toString() ?? '';
    final chatRoomId = extractChatRoomId(data);
    final orderId = extractOrderId(data);

    AppLogger.debug(
      'Handling navigation - Type: $type, ChatRoom: $chatRoomId, Order: $orderId',
    );

    if (_isOrderNotification(type) && orderId.isNotEmpty) {
      AppLogger.navigation('Navigating to order: $orderId');
      await safeNavigate('/order-details', parameters: {'orderId': orderId});
    } else if (type == 'NewChatMessage' && chatRoomId.isNotEmpty) {
      AppLogger.navigation('Navigating to chat: $chatRoomId');
      await safeNavigate(
        '/ticket-details',
        parameters: {'ticketId': chatRoomId},
      );
    } else {
      AppLogger.warning('No navigation action for type: $type');
    }
  }

  /// Store pending navigation from initial notification
  static void storeInitialNavigation(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    final chatRoomId = extractChatRoomId(data);
    final orderId = extractOrderId(data);

    if (_isOrderNotification(type) && orderId.isNotEmpty) {
      setPendingNavigation('/order-details', parameters: {'orderId': orderId});
    } else if (type == 'NewChatMessage' && chatRoomId.isNotEmpty) {
      setPendingNavigation(
        '/ticket-details',
        parameters: {'ticketId': chatRoomId},
      );
    } else if (type == 'kmUpdate') {
      setPendingNavigation('/km-update');
    }
  }

  /// Handle local notification tap payload
  static void handleLocalNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) return;

    AppLogger.debug('Local notification tapped - Payload: $payload');

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final type = data['type']?.toString() ?? '';
      final chatRoomId = data['chatRoomId']?.toString() ?? '';
      final orderId = data['orderId']?.toString() ?? '';

      if (_isOrderNotification(type) && orderId.isNotEmpty) {
        safeNavigate('/order-details', parameters: {'orderId': orderId});
      } else if (type == 'NewChatMessage' && chatRoomId.isNotEmpty) {
        safeNavigate('/ticket-details', parameters: {'ticketId': chatRoomId});
      } else if (type == 'kmUpdate') {
        safeNavigate('/km-update');
      } else {
        AppLogger.warning('No navigation action for type: $type');
      }
    } catch (e) {
      AppLogger.error('Error parsing notification payload: $e');
    }
  }

  static bool _isOrderNotification(String type) {
    return type == 'OrderStatusChanged' || type == 'NewOrder';
  }

  // ============ Data Parsing Helpers ============

  /// Safely parse nested JSON data from notification
  static Map<String, dynamic>? parseObjectData(String? objectData) {
    if (objectData == null || objectData.isEmpty) return null;

    try {
      dynamic decoded = objectData;

      // Handle multiple levels of JSON encoding
      while (decoded is String &&
          decoded.startsWith('"') &&
          decoded.endsWith('"')) {
        decoded = jsonDecode(decoded);
      }

      if (decoded is String) {
        final result = jsonDecode(decoded);
        return result is Map<String, dynamic> ? result : null;
      } else if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return null;
    } catch (e) {
      AppLogger.error('Error parsing object data: $e');
      AppLogger.debug('Object data: $objectData');
      return null;
    }
  }

  /// Extract chat room ID from notification data
  static String extractChatRoomId(Map<String, dynamic> data) {
    try {
      if (data['chatRoomId'] != null) {
        return data['chatRoomId'].toString();
      }

      final parsedObject = parseObjectData(data['object']?.toString());
      if (parsedObject != null) {
        final chatRoom = parsedObject['chatRoom'];
        if (chatRoom is Map<String, dynamic> && chatRoom['_id'] != null) {
          return chatRoom['_id'].toString();
        }

        if (parsedObject['_id'] != null) {
          return parsedObject['_id'].toString();
        }
      }

      return '';
    } catch (e) {
      AppLogger.error('Error extracting chat room ID: $e');
      return '';
    }
  }

  /// Extract order ID from notification data
  static String extractOrderId(Map<String, dynamic> data) {
    try {
      if (data['orderId'] != null) {
        return data['orderId'].toString();
      }
      if (data['objectId'] != null) {
        return data['objectId'].toString();
      }

      final parsedObject = parseObjectData(data['object']?.toString());
      if (parsedObject != null) {
        final order = parsedObject['order'];
        if (order is Map<String, dynamic> && order['_id'] != null) {
          return order['_id'].toString();
        }

        if (parsedObject['_id'] != null) {
          return parsedObject['_id'].toString();
        }
      }

      return '';
    } catch (e) {
      AppLogger.error('Error extracting order ID: $e');
      return '';
    }
  }
}
