import 'package:benchtask/app/core/local_db/local_db_storage_utils.dart';
import 'package:benchtask/app/feature/register/domain/entities/user.dart';

/// A singleton class responsible for managing user data operations 
/// using local storage.
class UserDataSource {
  // Singleton instance of UserDataSource.
  static final UserDataSource _instance = UserDataSource._internal();

  /// Private named constructor to prevent direct instantiation.
  UserDataSource._internal();

  // Instance of LocalStorageUtility for performing local storage operations.
  LocalStorageUtility localStorageUtility = LocalStorageUtility();

  /// Factory constructor to return the singleton instance.
  factory UserDataSource() {
    return _instance;
  }

  /// Creates a new user in the local storage.
  /// 
  /// This method takes a [User] object and attempts to store it in the
  /// local storage under the "userTable". Any exceptions during the 
  /// operation will be caught and logged.
  Future<void> createUser(User user) async {
    try {
      await localStorageUtility.createOrUpdate("userTable", user);
    } catch (e) {
      // Log the error for debugging purposes.
      print(e);
    }
  }

  /// Retrieves all user data from local storage.
  /// 
  /// This method returns a list of [User] objects that are fetched from
  /// the "userTable". If an exception occurs, it will be logged, and
  /// the exception will be rethrown for further handling.
  Future<List<User>> getAllUserData() async {
    try {
      final userData = await localStorageUtility.getAllData("userTable");
      return userData
          .map((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      // Log the error and rethrow for higher-level handling.
      print(e);
      rethrow;
    }
  }

  /// Deletes a user from the local storage by their ID.
  /// 
  /// This method takes a user ID as a string and attempts to delete the
  /// corresponding user record from the "userTable". It returns a boolean
  /// indicating whether the deletion was successful. In case of an error,
  /// it will return false.
  Future<bool> deleteUserById(String id) async {
    try {
      final result = await localStorageUtility.delete("userTable", id);
      return result;
    } catch (e) {
      // Log the error and return false to indicate failure.
      return false;
    }
  }
}
