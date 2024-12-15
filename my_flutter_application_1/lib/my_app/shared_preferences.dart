import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  Future<void> saveTasks(String key, List<String> value) async {
    if (_prefs != null) {
      await init();
    }
    await _prefs!.setStringList(key, value);
  }

  Future<List<String>?> getTasks(String key) async {
    await init();
    return _prefs!.getStringList(key);
  }
}
