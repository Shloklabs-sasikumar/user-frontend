import 'package:benchtask/app/core/storage_utils/storage_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageImpl implements StorageUtil {
  final SharedPreferences sharedPreferences;

  SecureStorageImpl({required this.sharedPreferences});

  @override
  Future<void> write({required String key, required String value}) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> read({required String key}) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> delete({required String key}) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    final keys = sharedPreferences.getKeys();
    for (String key in keys) {
      await sharedPreferences.remove(key);
    }
  }

  @override
  Future<Map<String, String>> readAll() async {
    final Map<String, String> allValues = {};
    final keys = sharedPreferences.getKeys();
    for (String key in keys) {
      final value = sharedPreferences.getString(key);
      if (value != null) {
        allValues[key] = value;
      }
    }
    return allValues;
  }
}
