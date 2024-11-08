import 'package:benchtask/app/core/storage_utils/secure_storage_impl.dart';

/// A data source class for handling timer-related data operations using secure storage.
class TimerDataSource {
  /// Singleton instance of [TimerDataSource].
  static final TimerDataSource _instance = TimerDataSource._internal();

  /// Instance of [SecureStorageImpl] used for secure data storage operations.
  SecureStorageImpl secureStorageImpl = SecureStorageImpl();

  /// Private constructor to enforce singleton pattern.
  TimerDataSource._internal();

  /// Factory constructor to return the singleton instance of [TimerDataSource].
  factory TimerDataSource() {
    return _instance;
  }

  /// Initializes the secure storage implementation.
  ///
  /// This method ensures that the secure storage is properly set up before any operations.
  Future<void> initlize() async {
    try {
      await secureStorageImpl.init();
    } catch (e) {
      print('Error initializing storage: $e');
    }
  }

  /// Stores data in secure storage with a given [key] and [value].
  ///
  /// [key] - The unique key to store the data.
  /// [value] - The value to be stored.
  Future<void> storeData(String key, String value) async {
    try {
      await initlize();
      await secureStorageImpl.write(key: key, value: value);
    } catch (e) {
      print('Error storing data for key $key: $e');
    }
  }

  /// Retrieves data from secure storage for a given [key].
  ///
  /// [key] - The unique key for the data to be retrieved.
  ///
  /// Returns the stored value as a [String], or `null` if an error occurs or the key is not found.
  Future<String?> getStoredData(String key) async {
    try {
      await initlize();
      return await secureStorageImpl.read(key: key);
    } catch (e) {
      print('Error reading data for key $key: $e');
      return null;
    }
  }

  /// Removes data from secure storage for a given [key].
  ///
  /// [key] - The unique key for the data to be removed.
  Future<void> removeData(String key) async {
    try {
      await initlize();
      await secureStorageImpl.delete(key: key);
    } catch (e) {
      print('Error removing data for key $key: $e');
    }
  }
}
