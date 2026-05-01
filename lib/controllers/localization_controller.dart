import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler_app/util/app_constants.dart';
import 'package:traveler_app/models/lang_model.dart';
import 'package:traveler_app/data/local/local_storage_service.dart';

class LocalizationController extends GetxController {
  final LocalStorageService localStorageService;

  LocalizationController({required this.localStorageService}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(
    AppConstants.languages[0].languageCode!,
    AppConstants.languages[0].countryCode,
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
          AppConstants.languages[0].languageCode!,
      localStorageService.getString(AppConstants.countryCode) ??
          AppConstants.languages[0].countryCode,
    );
    _isLtr = _locale.languageCode != 'ar' && _locale.languageCode != 'ur';

    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);

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
      _languages = AppConstants.languages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      for (var language in AppConstants.languages) {
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
