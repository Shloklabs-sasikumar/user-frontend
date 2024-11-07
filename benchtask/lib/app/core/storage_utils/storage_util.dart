abstract class StorageUtil {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
  Future<Map<String, String>> readAll();
}

class StorageUtility implements StorageUtil {
  // Singleton instance
  static final StorageUtility _instance = StorageUtility._internal();

  // Factory constructor
  factory StorageUtility() {
    return _instance;
  }

  // Private constructor for singleton pattern
  StorageUtility._internal();

  // Underlying storage implementation
  late StorageUtil _storage;

  // Method to initialize the storage implementation
  void init(StorageUtil storageImplementation) {
    _storage = storageImplementation;
  }

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }

  @override
  Future<Map<String, String>> readAll() {
    return _storage.readAll();
  }
}
