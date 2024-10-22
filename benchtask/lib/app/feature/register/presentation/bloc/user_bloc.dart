import 'package:benchtask/app/feature/register/application/use_cases/user_usecases.dart';
import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_event.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// UserBloc is responsible for handling user-related events and managing user states
class UserBloc extends Bloc<UserEvent, UserState> {
  // Use case that handles user-related business logic
  final UserUseCases userUseCases;

  // A list to store user data locally in memory
  List<User> _userDataList = [];

  // Constructor: Initializes the BLoC with a given use case and an initial state
  UserBloc(this.userUseCases) : super(RegistrationInitial()) {

    // Handles CreateUserEvent when a new user is created
    on<CreateUserEvent>((event, emit) async {
      // Emit the initial state while the event is processed
      emit(RegistrationInitial());

      try {
        // Emit loading state while the user is being created
        emit(RegistrationLoading());

        // Call use case to create the user in the repository
        await userUseCases.createUser(event.user);

        // Check if the user already exists, and add or update accordingly
        _checkExistingUser(event);

        // Emit success state with the updated user list
        emit(RegistrationSuccess(_userDataList));
      } catch (e) {
        // Print error to console (for debugging purposes)
        print(e);

        // Emit error state if something goes wrong
        emit(RegistrationError(e.toString()));
      }
    });

    // Handles GetAllUserEvent to fetch all users from the repository
    on<GetAllUserEvent>((event, emit) async {
      // Emit the initial state while the event is processed
      emit(RegistrationInitial());

      try {
        // Emit loading state while fetching user data
        emit(RegistrationLoading());

        // Fetch all users via the use case and update the list
        _userDataList = await userUseCases.getAllUserData();

        // Emit success state with the fetched user list
        emit(RegistrationSuccess(_userDataList));
      } catch (e) {
        // Print error to console (for debugging purposes)
        print(e);

        // Emit error state if something goes wrong
        emit(RegistrationError(e.toString()));
      }
    });

    // Handles DeleteUserEvent when a user is deleted
    on<DeleteUserEvent>((event, emit) async {
      try {
        // Emit loading state while the user is being deleted
        emit(RegistrationLoading());

        // Call use case to delete the user by ID
        bool deleteResponse = await userUseCases.deleteUserById(event.user.id.toString());

        // If the deletion is successful, remove the user from the local list
        if (deleteResponse) {
          _userDataList.removeWhere((user) => user.id == event.user.id);

          // Emit success state with the updated user list
          emit(RegistrationSuccess(_userDataList));
        }
      } catch (e) {
        // Emit error state if something goes wrong during deletion
        emit(RegistrationError(e.toString()));
      }
    });
  }

  // Helper function to check if the user already exists in the list
  void _checkExistingUser(CreateUserEvent event) {
    // Find the index of the existing user based on the user ID
    final existingUserIndex = _userDataList.indexWhere((user) => user.id == event.user.id);

    if (existingUserIndex != -1) {
      // If the user exists, update the existing entry
      _userDataList[existingUserIndex] = event.user;
    } else {
      // If the user does not exist, add the new user to the list
      _userDataList.add(event.user);
    }
  }
}
