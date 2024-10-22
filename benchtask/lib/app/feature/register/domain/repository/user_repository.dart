import 'package:benchtask/app/feature/register/domain/entities/user.dart';

/// An abstract class defining the contract for user data operations.
abstract class UserRepository {
  /// Creates a new user in the data source.
  /// 
  /// This method accepts a [User] object that contains the user's information
  /// and returns a [Future<void>] indicating that the operation is asynchronous.
  Future<void> createUser(User user);

  /// Retrieves all user data from the data source.
  /// 
  /// This method returns a [Future<List<User>>], which contains a list of 
  /// [User] objects representing all users in the data source.
  Future<List<User>> getAllUserData();

  /// Deletes a user from the data source by their ID.
  /// 
  /// This method accepts a user ID as a string and returns a [Future<bool>]
  /// indicating whether the deletion was successful. A return value of true
  /// signifies that the user was deleted, while false indicates failure.
  Future<bool> deleteUserById(String id);
}
