import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/models/lang_model.dart';
import 'package:traveler_app/data/local/local_storage_service.dart';

class LocalizationController extends GetxController {
  static final List<LanguageModel> supportedLanguages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'عربي', countryCode: 'SA', languageCode: 'ar'),
  ];

  final LocalStorageService localStorageService;

  LocalizationController({required this.localStorageService}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(
    supportedLanguages[0].languageCode!,
    supportedLanguages[0].countryCode,
  );
  bool _isLtr = true;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    if (_locale.languageCode == 'ar' || _locale.languageCode == 'ur') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = Locale(
      localStorageService.getString(AppConstants.languageCode) ??
          supportedLanguages[0].languageCode!,
      localStorageService.getString(AppConstants.countryCode) ??
          supportedLanguages[0].countryCode,
    );
    _isLtr = _locale.languageCode != 'ar' && _locale.languageCode != 'ur';

    for (int index = 0; index < supportedLanguages.length; index++) {
      if (supportedLanguages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(supportedLanguages);

    update();
  }

  void saveLanguage(Locale locale) async {
    await localStorageService.setString(
      AppConstants.languageCode,
      locale.languageCode,
    );
    await localStorageService.setString(
      AppConstants.countryCode,
      locale.countryCode!,
    );
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = [];
      _languages = supportedLanguages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      for (var language in supportedLanguages) {
        if (language.languageName!.toLowerCase().contains(
          query.toLowerCase(),
        )) {
          _languages.add(language);
        }
      }
    }
    update();
  }
}
