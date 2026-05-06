import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/app_bottom_sheet.dart';

/// Opens an [AppBottomSheet] hosting a filter [form]. The form's own
/// "Search" / "Apply" actions should call `Navigator.of(context).pop()`
/// (or `Get.back()`) to dismiss the sheet.
Future<void> showFilterBottomSheet(
  BuildContext context, {
  required Widget form,
  String? title,
}) {
  return AppBottomSheet.show<void>(
    title: title ?? 'filters'.tr,
    child: form,
  );
}
