import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  static SharedPreferences? _prefs;

  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    _checkInitialized();
    return _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    _checkInitialized();
    return _prefs?.getString(key);
  }

  String? getStringNotStatic(String key) {
    _checkInitialized();
    return _prefs?.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    _checkInitialized();
    return _prefs!.setInt(key, value);
  }

  static int? getInt(String key) {
    _checkInitialized();
    return _prefs?.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    _checkInitialized();
    return _prefs!.setDouble(key, value);
  }

  static double? getDouble(String key) {
    _checkInitialized();
    return _prefs?.getDouble(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    _checkInitialized();
    return _prefs!.setBool(key, value);
  }

  static bool? getBool(String key) {
    _checkInitialized();
    return _prefs?.getBool(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    _checkInitialized();
    return _prefs!.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    _checkInitialized();
    return _prefs?.getStringList(key);
  }

  static Future<bool> remove(String key) async {
    _checkInitialized();
    return _prefs!.remove(key);
  }

  static Future<bool> clear() async {
    _checkInitialized();
    return _prefs!.clear();
  }

  static bool containsKey(String key) {
    _checkInitialized();
    return _prefs!.containsKey(key);
  }

  static void _checkInitialized() {
    if (_prefs == null) {
      init();
    }
  }
}
