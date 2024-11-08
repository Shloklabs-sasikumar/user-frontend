import 'package:shared_preferences/shared_preferences.dart';
import 'package:benchtask/app/core/storage_utils/storage_util.dart';

class SecureStorageImpl implements StorageUtil {
  SharedPreferences? sharedPreferences;

  // Initializes the SharedPreferences instance.
  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void _checkInitialization() {
    if (sharedPreferences == null) {
      throw Exception('SharedPreferences has not been initialized. Call init() first.');
    }
  }

  @override
  Future<void> write({required String key, required String value}) async {
    _checkInitialization();
    await sharedPreferences!.setString(key, value);
  }

  @override
  Future<String?> read({required String key}) async {
    _checkInitialization();
    return sharedPreferences!.getString(key);
  }

  @override
  Future<void> delete({required String key}) async {
    _checkInitialization();
    await sharedPreferences!.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _checkInitialization();
    for (String key in sharedPreferences!.getKeys()) {
      await sharedPreferences!.remove(key);
    }
  }

  @override
  Future<Map<String, String>> readAll() async {
    _checkInitialization();
    final Map<String, String> allValues = {};
    for (String key in sharedPreferences!.getKeys()) {
      final value = sharedPreferences!.getString(key);
      if (value != null) {
        allValues[key] = value;
      }
    }
    return allValues;
  }
}
