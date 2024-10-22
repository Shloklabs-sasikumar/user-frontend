import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:benchtask/app/feature/register/domain/repository/user_repository.dart';

/// A class that encapsulates user-related use cases and interacts with the user repository.
class UserUseCases {
  /// The repository responsible for user data operations.
  final UserRepository _userRepository;

  /// Constructor that initializes the UserUseCases with a UserRepository instance.
  UserUseCases(this._userRepository);

  /// Creates a new user by delegating the call to the user repository.
  /// 
  /// This method accepts a [User] object and calls the [createUser] method 
  /// of the [_userRepository] to perform the actual user creation.
  Future<void> createUser(User user) {
    return _userRepository.createUser(user);
  }

  /// Retrieves all user data from the repository.
  /// 
  /// This method calls the [getAllUserData] method of the [_userRepository]
  /// to fetch a list of all users. It returns a list of [User] objects.
  Future<List<User>> getAllUserData() {
    return _userRepository.getAllUserData();
  }

  /// Deletes a user by their ID.
  /// 
  /// This method accepts a user ID as a string and delegates the deletion 
  /// operation to the [_userRepository]. It returns a boolean indicating 
  /// whether the deletion was successful.
  Future<bool> deleteUserById(String id) {
    return _userRepository.deleteUserById(id);
  }
}
