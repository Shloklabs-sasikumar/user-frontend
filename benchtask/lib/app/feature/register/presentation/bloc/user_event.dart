import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

/// Base abstract class representing a user-related event.
/// This class extends Equatable to provide value equality for events.
abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event for creating a new user.
///
/// This class encapsulates the data required to create a user,
/// specifically a [User] object. It extends the [UserEvent] class.
class CreateUserEvent extends UserEvent {
  final User user;

  /// Constructor for creating a CreateUserEvent.
  ///
  /// Takes a [User] object as a required parameter.
  CreateUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Event for retrieving all users.
///
/// This class represents an event that triggers the retrieval of
/// all user data. It extends the [UserEvent] class.
class GetAllUserEvent extends UserEvent {
  @override
  List<Object?> get props => [];
}

/// Event for deleting a user.
///
/// This class encapsulates the data required to delete a user,
/// specifically a [User] object. It extends the [UserEvent] class.
class DeleteUserEvent extends UserEvent {
  final User user;

  /// Constructor for creating a DeleteUserEvent.
  ///
  /// Takes a [User] object as a required parameter.
  DeleteUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
