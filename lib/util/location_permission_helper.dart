import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/custom_snackbar.dart';
import 'package:traveler_app/util/app_logger.dart';
import 'package:traveler_app/util/app_theme.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class LocationPermissionResult {
  final LocationPermissionStatus status;
  final Position? position;
  final String? errorMessage;

  LocationPermissionResult({
    required this.status,
    this.position,
    this.errorMessage,
  });

  bool get isGranted => status == LocationPermissionStatus.granted;
}

class LocationPermissionHelper {
  /// Check current location permission status
  static Future<LocationPermissionStatus> checkPermissionStatus() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationPermissionStatus.serviceDisabled;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        return LocationPermissionStatus.deniedForever;
      }

      if (permission == LocationPermission.denied) {
        return LocationPermissionStatus.denied;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return LocationPermissionStatus.granted;
      }

      return LocationPermissionStatus.denied;
    } catch (e) {
      AppLogger.error('Error checking location permission: $e');
      return LocationPermissionStatus.denied;
    }
  }

  /// Request location permission
  static Future<LocationPermissionResult> requestPermission({
    bool openLocationSettings = true,
  }) async {
    try {
      // First check if service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (openLocationSettings) {
          await Get.defaultDialog(
            title: 'location_service_disabled'.tr,
            middleText: 'enable_location_message'.tr,
            textConfirm: 'settings'.tr,
            textCancel: 'cancel'.tr,
            buttonColor: AppTheme.primary,
            confirmTextColor: AppTheme.textOnPrimary,
            onConfirm: () {
              Geolocator.openLocationSettings();
              Get.back();
            },
            onCancel: () => Get.back(),
          );
        }

        GlobalSnackBar.show('location_service_disabled'.tr, SnackType.error);
        return LocationPermissionResult(
          status: LocationPermissionStatus.serviceDisabled,
          errorMessage: 'location_service_disabled'.tr,
        );
      }

      // Check current permission
      LocationPermission permission = await Geolocator.checkPermission();

      // If denied, request permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          GlobalSnackBar.show('location_permission_denied'.tr, SnackType.error);
          return LocationPermissionResult(
            status: LocationPermissionStatus.denied,
            errorMessage: 'location_permission_denied'.tr,
          );
        }
      }

      // If denied forever
      if (permission == LocationPermission.deniedForever) {
        if (openLocationSettings) {
          await Get.defaultDialog(
            title: 'location_permission_denied_forever'.tr,
            middleText: 'enable_location_permission_message'.tr,
            textConfirm: 'settings'.tr,
            textCancel: 'cancel'.tr,
            buttonColor: AppTheme.primary,
            confirmTextColor: AppTheme.textOnPrimary,
            onConfirm: () {
              Geolocator.openAppSettings();
              Get.back();
            },
            onCancel: () => Get.back(),
          );
        }

        GlobalSnackBar.show(
          'location_permission_denied_forever'.tr,
          SnackType.error,
        );
        return LocationPermissionResult(
          status: LocationPermissionStatus.deniedForever,
          errorMessage: 'location_permission_denied_forever'.tr,
        );
      }

      // Permission granted - get current location
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        try {
          final position = await getCurrentLocation();
          GlobalSnackBar.show(
            'location_permission_granted'.tr,
            SnackType.success,
          );
          return LocationPermissionResult(
            status: LocationPermissionStatus.granted,
            position: position,
          );
        } catch (e) {
          AppLogger.error(
            'Error getting location after permission granted: $e',
          );
          return LocationPermissionResult(
            status: LocationPermissionStatus.granted,
            errorMessage: 'error_getting_location'.tr,
          );
        }
      }

      return LocationPermissionResult(
        status: LocationPermissionStatus.denied,
        errorMessage: 'location_permission_denied'.tr,
      );
    } catch (e) {
      AppLogger.error('Error requesting location permission: $e');
      GlobalSnackBar.show('error_requesting_location'.tr, SnackType.error);

      return LocationPermissionResult(
        status: LocationPermissionStatus.denied,
        errorMessage: 'error_requesting_location'.tr,
      );
    }
  }

  /// Get current location
  static Future<Position> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );
      AppLogger.debug(
        'Current location: ${position.latitude}, ${position.longitude}',
      );
      return position;
    } catch (e) {
      AppLogger.error('Error getting current location: $e');
      rethrow;
    }
  }

  /// Recheck permission (useful when returning from settings)
  static Future<LocationPermissionResult> recheckPermission() async {
    try {
      final status = await checkPermissionStatus();

      if (status == LocationPermissionStatus.granted) {
        try {
          final position = await getCurrentLocation();
          GlobalSnackBar.show(
            'location_permission_granted'.tr,
            SnackType.error,
          );

          return LocationPermissionResult(status: status, position: position);
        } catch (e) {
          return LocationPermissionResult(
            status: status,
            errorMessage: 'error_getting_location'.tr,
          );
        }
      }

      return LocationPermissionResult(status: status);
    } catch (e) {
      AppLogger.error('Error rechecking permission: $e');
      return LocationPermissionResult(status: LocationPermissionStatus.denied);
    }
  }

  /// Open location settings
  static Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      AppLogger.error('Error opening location settings: $e');
      GlobalSnackBar.show('error_opening_settings'.tr, SnackType.error);
    }
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      AppLogger.error('Error opening app settings: $e');
      GlobalSnackBar.show('error_opening_settings'.tr, SnackType.error);

      return false;
    }
  }

  /// Check if location permission is granted
  static Future<bool> isPermissionGranted() async {
    final status = await checkPermissionStatus();
    return status == LocationPermissionStatus.granted;
  }

  /// Get permission and location in one call
  static Future<LocationPermissionResult> getPermissionAndLocation() async {
    final status = await checkPermissionStatus();

    if (status == LocationPermissionStatus.granted) {
      try {
        final position = await getCurrentLocation();
        return LocationPermissionResult(status: status, position: position);
      } catch (e) {
        return LocationPermissionResult(
          status: status,
          errorMessage: 'error_getting_location'.tr,
        );
      }
    }

    return LocationPermissionResult(status: status);
  }
}
