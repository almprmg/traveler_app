import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../util/app_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Generic helpers
  Future<bool> setString(String key, String value) async =>
      _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<bool> setBool(String key, bool value) async =>
      _prefs.setBool(key, value);
  bool getBool(String key) => _prefs.getBool(key) ?? false;

  Future<bool> setInt(String key, int value) async => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> remove(String key) async => _prefs.remove(key);
  Future<bool> clear() async {
    for (String key in _prefs.getKeys()) {
      await _prefs.remove(key);
    }
    return true;
  }

  // Common getters/setters used across the app
  Future<bool> setToken(String token) async =>
      setString(AppConstants.tokenCode, token);
  String? getToken() => getString(AppConstants.tokenCode);
  // User data
  Future<bool> setUser(Map<String, dynamic> user) async =>
      setString(AppConstants.userKey, json.encode(user));

  // Common getters/setters used across the app
  Map<String, dynamic>? getUser() {
    final str = getString(AppConstants.userKey);
    if (str == null) return null;
    return json.decode(str) as Map<String, dynamic>?;
  }

  Future<bool> removeAuthData() async {
    await remove(AppConstants.tokenCode);
    await remove(AppConstants.userKey);
    return true;
  }

  Future<bool> setCustomerId(String id) async =>
      setString(AppConstants.customerId, id);
  String? getCustomerId() {
    final user = getUser();
    return user?['_id'] as String?;
  }

  Future<bool> setCityId(String id) async => setString(AppConstants.cityId, id);
  String? getCityId() => getString(AppConstants.cityId);

  // Search history
  static const _searchHistoryKey = 'search_history';

  Future<bool> setSearchHistory(List<String> queries) async =>
      setString(_searchHistoryKey, json.encode(queries));

  List<String> getSearchHistory() {
    final str = getString(_searchHistoryKey);
    if (str == null || str.isEmpty) return [];
    try {
      final decoded = json.decode(str);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
    } catch (_) {}
    return [];
  }
}
