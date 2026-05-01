import '../../base/custom_snackbar.dart';
import 'package:http/http.dart' as http;

class ApiChecker {
  static Future<void> Function()? onUnauthorized;

  static void checkApi(http.Response response) {
    if (response.statusCode == 401) {
      onUnauthorized?.call();
    } else {
      GlobalSnackBar.show(response.body, SnackType.error, useToast: true);
    }
  }
}
