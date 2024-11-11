
import 'package:benchtask/app/feature/timer/application/use_cases/timer_usecases.dart';
import 'package:benchtask/app/feature/timer/infrastructure/repositories_impl/timer_repository_impl.dart';

/// A singleton provider class for user use cases.
class UseCaseProvider {
 /// The instance of UserUseCases that provides methods for user-related operations.

 late final TimerUseCases timerUseCases;

 // Private named constructor to prevent direct instantiation.
 UseCaseProvider._internal();

 // The singleton instance of UseCaseProvider.
 static final UseCaseProvider _instance = UseCaseProvider._internal();

 /// Factory constructor to return the singleton instance of UseCaseProvider.
 /// This ensures that only one instance of UseCaseProvider is created.
 factory UseCaseProvider() {
  return _instance;
 }

 /// Initializes the UserUseCases instance with the local repository implementation.
 /// This method should be called before using any user-related use cases.
 void initialize() {

  timerUseCases = TimerUseCases(TimerRepositoryImpl());
 }
}
