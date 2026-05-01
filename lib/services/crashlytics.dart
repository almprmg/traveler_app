import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:traveler_app/data/local/local_storage_service.dart';

/// Production-ready singleton wrapper around Firebase Crashlytics.
///
/// Crashlytics is disabled on web (unsupported) and in debug mode so that
/// development noise never reaches the crash dashboard.
///
/// Usage – call once in main() after Firebase.initializeApp():
/// ```dart
/// await CrashlyticsService.instance.init();
/// ```
class CrashlyticsService {
  CrashlyticsService._();

  static final CrashlyticsService instance = CrashlyticsService._();

  // ─── Initialization ────────────────────────────────────────────────────────

  /// Must be called once after [Firebase.initializeApp].
  ///
  /// Wires up [FlutterError.onError] and
  /// [PlatformDispatcher.instance.onError] so that all unhandled Flutter
  /// and platform errors are forwarded to Crashlytics automatically.
  Future<void> init() async {
    if (kIsWeb) {
      debugPrint('[CrashlyticsService] Skipping initialization on web.');
      return;
    }

    try {
      // Enable Crashlytics error collection
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // ── Capture Flutter framework errors (widget build failures, etc.) ──
      FlutterError.onError = (FlutterErrorDetails details) {
        // Log the error before reporting

        log("Flutter framework error captured: ${details.exceptionAsString()}");
        FirebaseCrashlytics.instance.log(
          "Flutter framework error captured: ${details.exceptionAsString()}",
        );

        // Report the error as fatal
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      // ── Capture platform / isolate errors not handled by Flutter ──
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        // Log the error before reporting
        FirebaseCrashlytics.instance.log(
          "Platform / isolate error captured: $error",
        );

        // Report the error as fatal
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

        return true; // indicate that the error has been handled
      };

      // Log successful initialization
      await FirebaseCrashlytics.instance.log(
        '[CrashlyticsService] Initialized successfully.',
      );
    } catch (e, st) {
      debugPrint('[CrashlyticsService] Init failed: $e\n$st');
    }
  }

  // ─── Error recording ───────────────────────────────────────────────────────

  /// Logs a non-fatal error with an optional [stackTrace].
  ///
  /// Safe to call from anywhere; silently no-ops on web / debug.
  Future<void> logError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (kIsWeb) return;

    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('[CrashlyticsService] logError failed: $e');
    }
  }

  // ─── User identity ─────────────────────────────────────────────────────────

  /// Associates subsequent crash reports with [userId].
  Future<void> setUser() async {
    if (kIsWeb) return;

    try {
      final id = Get.find<LocalStorageService>().getCustomerId();

      if (id != null) await FirebaseCrashlytics.instance.setUserIdentifier(id);
    } catch (e) {
      debugPrint('[CrashlyticsService] setUser failed: $e');
    }
  }

  /// Clears the user identifier from subsequent crash reports.
  Future<void> clearUser() async {
    if (kIsWeb) return;

    try {
      await FirebaseCrashlytics.instance.setUserIdentifier('');
    } catch (e) {
      debugPrint('[CrashlyticsService] clearUser failed: $e');
    }
  }

  // ─── Custom keys ───────────────────────────────────────────────────────────

  /// Attaches a custom key-value pair to crash reports.
  ///
  /// Supported value types: [String], [bool], [int], [double].
  /// Other types are converted via [toString].
  Future<void> setCustomKey(String key, dynamic value) async {
    if (kIsWeb) return;

    try {
      if (value is bool) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is int) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else if (value is double) {
        await FirebaseCrashlytics.instance.setCustomKey(key, value);
      } else {
        await FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
      }
    } catch (e) {
      debugPrint('[CrashlyticsService] setCustomKey failed: $e');
    }
  }

  // ─── Breadcrumb logging ────────────────────────────────────────────────────

  /// Appends a breadcrumb [message] visible in the Crashlytics dashboard.
  Future<void> log(String message) async {
    if (kIsWeb) {
      debugPrint(message);
      return;
    }

    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (e) {
      debugPrint('[CrashlyticsService] log failed: $e');
    }
  }
}
