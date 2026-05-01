import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:traveler_app/util/app_logger.dart';

class AppUpdateService {
  // Check for available updates
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        return updateInfo;
      }
      AppLogger.info('no_update'.tr);
      return null;
    } catch (e) {
      AppLogger.error('Error checking for update: $e');
      return null;
    }
  }

  // Immediate Update
  Future<void> performImmediateUpdate() async {
    try {
      AppUpdateInfo? updateInfo = await checkForUpdate();

      if (updateInfo != null && updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      AppLogger.error('Error performing immediate update: $e');
    }
  }

  // Flexible Update
  Future<void> startFlexibleUpdate(BuildContext context) async {
    try {
      AppUpdateInfo? updateInfo = await checkForUpdate();

      if (updateInfo != null && updateInfo.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();

        InAppUpdate.completeFlexibleUpdate()
            .then((_) {
              _showUpdateCompleteSnackbar(Get.context!);
            })
            .catchError((e) {
              AppLogger.error('Error completing flexible update: $e');
            });
      }
    } catch (e) {
      AppLogger.error('Error starting flexible update: $e');
    }
  }

  // Show snackbar
  void _showUpdateCompleteSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('update_downloaded'.tr),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'restart'.tr,
          onPressed: () {
            InAppUpdate.completeFlexibleUpdate();
          },
        ),
      ),
    );
  }

  // Smart update
  Future<void> checkAndUpdate(
    BuildContext context, {
    bool forceImmediate = false,
  }) async {
    AppLogger.info('checkAndUpdate called');
    if (kIsWeb || (defaultTargetPlatform != TargetPlatform.android)) {
      AppLogger.warning('Update not supported on web platform.');
      return;
    }
    try {
      AppUpdateInfo? updateInfo = await checkForUpdate();

      if (updateInfo == null) {
        AppLogger.info('no_update'.tr);
        return;
      }

      if (forceImmediate && updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (updateInfo.flexibleUpdateAllowed) {
        await startFlexibleUpdate(Get.context!);
      } else if (updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      AppLogger.error('Error in checkAndUpdate: $e');
    }
  }
}
