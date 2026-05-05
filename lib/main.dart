import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:traveler_app/base/offline_banner.dart';
import 'package:traveler_app/controllers/localization_controller.dart';
import 'package:traveler_app/models/messages.dart';
import 'package:traveler_app/routes.dart';
import 'package:traveler_app/util/app_theme.dart';
import 'package:traveler_app/util/keyboard_dismisser.dart';
import 'helper/get_di.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final Map<String, Map<String, String>> languages = await di.init();

  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localeController) {
        return GetMaterialApp(
          title: 'Traveler',
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          textDirection: localeController.isLtr
              ? TextDirection.ltr
              : TextDirection.rtl,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(
            LocalizationController.supportedLanguages[0].languageCode!,
            LocalizationController.supportedLanguages[0].countryCode,
          ),
          theme: AppTheme.theme,
          defaultTransition: Transition.topLevel,
          transitionDuration: const Duration(milliseconds: 300),
          initialRoute: navRoute,
          getPages: routes,
          navigatorObservers: [KeyboardDismissRouteObserver()],
          builder: (context, child) {
            return KeyboardDismisser(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(
                      context,
                    ).textScaler.scale(1.0).clamp(1.0, 1.2),
                  ),
                ),
                child: OfflineBanner(child: child!),
              ),
            );
          },
        );
      },
    );
  }
}
