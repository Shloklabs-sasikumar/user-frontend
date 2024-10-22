/// Abstract class defining the contract for local storage utility operations.
/// This interface outlines the core functionalities required for interacting
/// with a local database, such as opening the database, performing CRUD operations,
/// and retrieving data by keys.
abstract class StorageLocalUtils {

  /// Opens the local SQLite database using the provided [dbName] and [tableName].
  /// This method ensures that the database is available for operations.
  Future<void> openDb(String dbName, String tableName);

  /// Inserts or updates a record in the specified [tableName] using the provided [data].
  /// If the data with the specified ID already exists, it will be updated;
  /// otherwise, a new record will be inserted.
  Future<void> createOrUpdate(String tableName, dynamic data);

  /// Retrieves a specific record from the database using the [id] from the given [tableName].
  /// Returns the value associated with the provided ID.
  Future<dynamic> read(String tableName, String id);

  /// Deletes a record from the [tableName] where the ID matches the given [id].
  /// Returns true if the deletion was successful, false otherwise.
  Future<bool> delete(String tableName, String id);

  /// Clears all records from the database by removing all entries from the specified table.
  Future<void> clearDb();

  /// Retrieves all records from the specified [tableName].
  /// Returns a list of maps where each map represents a key-value pair in the table.
  Future<List<Map<String, dynamic>>> getAllData(String tableName);

  /// Retrieves a specific record by its ID from the given [tableName].
  /// Returns the record if found, or null if no matching entry exists.
  Future<dynamic> getDataById(String tableName, String id);
}

/// Concrete implementation of the [StorageLocalUtils] interface, which provides
/// functionality for interacting with a local SQLite database using the Singleton pattern.
class LocalStorageUtility implements StorageLocalUtils {

  /// The singleton instance of [LocalStorageUtility].
  static final LocalStorageUtility _instance = LocalStorageUtility._internal();

  /// Factory constructor that always returns the singleton instance, ensuring
  /// that only one instance of [LocalStorageUtility] exists throughout the app.
  factory LocalStorageUtility() => _instance;

  /// Private constructor to implement the singleton pattern.
  /// This ensures the class cannot be instantiated externally.
  LocalStorageUtility._internal();

  /// Private variable that stores a reference to the actual storage implementation.
  /// The [StorageLocalUtils] implementation must be provided and initialized before usage.
  StorageLocalUtils? _storage;

  /// Initializes the storage with a specific implementation of [StorageLocalUtils].
  /// This allows the app to switch between different storage backends if needed.
  void init(StorageLocalUtils storageImplementation) {
    _storage = storageImplementation;
  }

  /// Opens the database using the provided [dbName] and [tableName].
  /// Delegates the operation to the underlying storage implementation.
  @override
  Future<void> openDb(String dbName, String tableName) async {
    return _storage!.openDb(dbName, tableName);
  }

  /// Creates or updates a record in the database for the specified [tableName].
  /// Before performing the operation, it ensures that the storage is initialized,
  /// throwing an exception if not. Logs any errors that occur during the operation.
  @override
  Future<void> createOrUpdate(String tableName, dynamic data) async {
    try {
      // Ensure the storage is initialized
      if (_storage == null) {
        throw Exception('Storage is not initialized');
      }
      // Perform create or update operation
      await _storage!.createOrUpdate(tableName, data);
    } catch (e) {
      // Log any errors that occur during the operation
      print('Error in createOrUpdate: $e');
    }
  }

  /// Reads a specific record from the [tableName] using the provided [id].
  /// Delegates the read operation to the underlying storage implementation.
  @override
  Future<dynamic> read(String tableName, String id) async {
    return await _storage!.read(tableName, id);
  }

  /// Deletes a record from the [tableName] where the ID matches the given [id].
  /// Returns true if the deletion was successful, false otherwise.
  /// Catches and logs any exceptions during the delete operation.
  @override
  Future<bool> delete(String tableName, String id) async {
    try {
      final result = await _storage!.delete(tableName, id);
      return result;
    } catch (e) {
      // Log the error and return false if an exception occurs
      print(e);
      return false;
    }
  }

  /// Clears all records from the database.
  /// Delegates the operation to the underlying storage implementation.
  @override
  Future<void> clearDb() async {
    return await _storage!.clearDb();
  }

  /// Retrieves all records from the specified [tableName].
  /// Returns a list of maps where each map represents a key-value pair in the table.
  @override
  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    return await _storage!.getAllData(tableName);
  }

  /// Retrieves a specific record by its [id] from the [tableName].
  /// Delegates the operation to the underlying storage implementation.
  @override
  Future<dynamic> getDataById(String tableName, String id) async {
    return await _storage!.getDataById(tableName, id);
  }
}
