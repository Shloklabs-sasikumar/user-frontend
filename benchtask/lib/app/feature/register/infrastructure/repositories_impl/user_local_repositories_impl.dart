import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:benchtask/app/feature/register/domain/repository/user_repository.dart';
import 'package:benchtask/app/feature/register/infrastructure/data/datasource/user_local_datasource.dart';

/// Concrete implementation of the UserRepository interface
/// that interacts with local data storage to manage user data.
class UserLocalRepositoriesImpl implements UserRepository {
  // Instance of UserDataSource for performing user data operations.
  UserDataSource _userDataSource = UserDataSource();

  /// Creates a new user in local storage.
  /// 
  /// This method implements the createUser function from the UserRepository 
  /// interface, and it takes a [User] object as an argument. It calls the 
  /// createUser method of UserDataSource to persist the user data.
  @override
  Future<void> createUser(User user) async {
    await _userDataSource.createUser(user);
  }

  /// Retrieves all user data from local storage.
  /// 
  /// This method implements the getAllUserData function from the UserRepository 
  /// interface. It calls the getAllUserData method of UserDataSource to 
  /// fetch all user records and returns them as a list of [User] objects.
  @override
  Future<List<User>> getAllUserData() async {
    // Fetch and return all user data from local storage.
    return await _userDataSource.getAllUserData();
  }

  /// Deletes a user from local storage by their ID.
  /// 
  /// This method implements the deleteUserById function from the UserRepository 
  /// interface. It takes a user ID as a string and calls the deleteUserById 
  /// method of UserDataSource to remove the corresponding user record.
  @override
  Future<bool> deleteUserById(String id) async {
    // Delete the user by ID and return the result.
    return await _userDataSource.deleteUserById(id);
  }
}
