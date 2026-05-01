import 'package:traveler_app/util/app_constants.dart';

class UrlHandler {
  static String handleUrl(String url) {
    return AppConstants.apiUrl + url.split('api/').last;
  }
}
