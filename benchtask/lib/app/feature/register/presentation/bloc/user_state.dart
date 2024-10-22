// Abstract base class for UserState, extending Equatable for value comparison
import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

/// Base class representing the various states of user registration.
///
/// This class extends [Equatable] to provide value equality for the states.
abstract class UserState extends Equatable {
  @override
  List<Object> get props => []; // Override props to return an empty list by default
}

/// Initial state of the registration process.
///
/// This class represents the state before any registration action has occurred.
class RegistrationInitial extends UserState {}

/// Loading state during the registration process.
///
/// This class represents the state while user registration is in progress.
class RegistrationLoading extends UserState {}

/// Successful registration state.
///
/// This class represents the state when registration is successful,
/// holding a list of registered users.
class RegistrationSuccess extends UserState {
  final List<User> users; // List of users after successful registration

  /// Constructor for RegistrationSuccess.
  ///
  /// Takes a [List<User>] as a parameter.
  RegistrationSuccess(this.users);

  @override
  List<Object> get props => [users]; // Override props to return the list of users
}

/// Error state during the registration process.
///
/// This class represents the state when an error occurs during registration,
/// holding the error message.
class RegistrationError extends UserState {
  final String error; // Error message

  /// Constructor for RegistrationError.
  ///
  /// Takes a [String] error message as a parameter.
  RegistrationError(this.error);

  @override
  List<Object> get props => [error]; // Override props to return the error message
}
