import 'package:benchtask/app/core/local_db/local_db_storage_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// This class implements the [StorageLocalUtils] interface and provides
/// methods for performing CRUD operations using SQLite as the local storage.
class LocalStorageImpl implements StorageLocalUtils {
  // SQLite database instance
  Database? _database;

  /// Opens the SQLite database with the given [dbName] and creates the table if it doesn't exist.
  /// If the database is already open, it skips re-opening it.
  /// The table schema is defined for storing user-related data.
  @override
  Future<void> openDb(String dbName, String tableName) async {
    // Get the path where the database should be stored on the device
    final String path = join(await getDatabasesPath(), dbName);

    // Open the database and create the table if it doesn't already exist
    _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
              'CREATE TABLE IF NOT EXISTS $tableName (id TEXT PRIMARY KEY, name TEXT, age TEXT, email TEXT, address TEXT, pinCode TEXT)'
          );
        }
    );

    print("database: ${_database}");

    // Check if the database is successfully opened
    if (_database == null) {
      throw Exception('Database is not open');
    }
  }

  /// Inserts or updates a record in the database using the provided [data].
  /// The method first checks if the record with the same [id] exists and updates it if found.
  /// If no existing record is found, it inserts a new record.
  @override
  Future<void> createOrUpdate(String tableName, dynamic data) async {
    // Ensure that the database is open before performing any operation
    await _checkDatabaseOpened();
    print("database: ${_database}");

    // Extract the 'id' from the provided data
    String id = data.id;

    try {
      if (id.isNotEmpty || id != null) {
        // Query the database to check if the record already exists
        List<Map<String, dynamic>> existingRecords = await _database!.query(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        );

        if (existingRecords.isNotEmpty) {
          // If the record exists, update the existing data
          await _database!.update(
            tableName,
            data.toMap(),
            where: 'id = ?',
            whereArgs: [id],
          );
        } else {
          // If the record does not exist, insert a new one
          await _database!.insert(tableName, data.toMap());
        }
      } else {
        // If no ID is provided, insert the data as a new record
        await _database!.insert(tableName, data.toMap());
      }
    } catch (e) {
      // Log the error if something goes wrong
      print("e: $e");
    }
  }

  /// Reads and returns a value from the database for a given [id] in the specified [tableName].
  /// If no data is found, it returns null.
  @override
  Future<dynamic> read(String tableName, String id) async {
    // Ensure that the database is open before performing any operation
    await _checkDatabaseOpened();

    // Query the database to get the data by the provided ID
    final List<Map<String, dynamic>> maps = await _database!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    // If data is found, return the value
    if (maps.isNotEmpty) {
      return maps.first['value'];
    }

    // Return null if no data is found
    return null;
  }

  /// Deletes a record from the database using the provided [id].
  /// If the deletion is successful, it returns true; otherwise, it returns false.
  @override
  Future<bool> delete(String tableName, String id) async {
    // Ensure that the database is open before performing any operation
    await _checkDatabaseOpened();

    try {
      // Perform the delete operation on the database
      await _database!.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return true; // Return true if deletion is successful
    } catch (e) {
      return false; // Return false if an error occurs
    }
  }

  /// Clears all records from the specified table in the database.
  @override
  Future<void> clearDb() async {
    // Ensure that the database is open before performing any operation
    await _checkDatabaseOpened();

    // Delete all records from the 'my_table' (this should be dynamic to allow table names)
    await _database!.delete('my_table');
  }

  /// Retrieves and returns all data from the given [tableName].
  /// If there is an error querying the database, it returns an empty list.
  @override
  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    // Ensure that the database is open before performing any operation
    await _checkDatabaseOpened();

    // Query and return all data from the specified table
    try {
      final List<Map<String, dynamic>> maps = await _database!.query(tableName);
      return maps; // Return the result as a list of maps
    } catch (e) {
      // Handle any errors that occur during querying
      print("Error querying database: $e");
      return []; // Return an empty list if an error occurs
    }
  }

  /// Retrieves and returns a specific record from the database using the provided [id].
  /// If no record is found, it returns null.
  @override
  Future<Map<String, dynamic>?> getDataById(String tableName, String id) async {
    // Ensure that the database is open before performing any operation
    await _checkDatabaseOpened();

    // Query the database to get the data by the provided ID
    final List<Map<String, dynamic>> maps = await _database!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    // If data is found, return the first match
    if (maps.isNotEmpty) {
      return maps.first;
    }

    // Return null if no data is found
    return null;
  }

  /// Checks if the SQLite database is opened.
  /// If the database is not open, it attempts to open it using the [openDb] method.
  Future<void> _checkDatabaseOpened() async {
    // If the database is not opened, attempt to open it
    if (_database == null) {
      await openDb("User.db", "userTable");
    }
  }
}
