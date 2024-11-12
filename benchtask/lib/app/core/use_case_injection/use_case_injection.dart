import 'package:benchtask/app/feature/timer/application/use_cases/timer_usecases.dart';
import 'package:benchtask/app/feature/timer/infrastructure/repositories_impl/timer_repository_impl.dart';

/// A singleton provider class responsible for managing and providing instances of use cases.
/// This class ensures that only one instance of each use case (like TimerUseCases) is created and used
/// throughout the app, promoting efficient resource management and adhering to the singleton pattern.
class UseCaseProvider {
 /// Instance of `TimerUseCases` that provides methods for handling timer-related operations,
 /// such as starting, pausing, and resuming the timer.
 late final TimerUseCases timerUseCases;

 // Private named constructor to restrict direct instantiation of UseCaseProvider.
 UseCaseProvider._internal();

 /// Singleton instance of UseCaseProvider.
 static final UseCaseProvider _instance = UseCaseProvider._internal();

 /// Factory constructor that returns the singleton instance of `UseCaseProvider`.
 /// Ensures that only one instance of `UseCaseProvider` exists at any time.
 factory UseCaseProvider() {
  return _instance;
 }

 /// Initializes the `TimerUseCases` instance with its corresponding repository implementation.
 /// This method should be called before accessing `timerUseCases` to ensure it is correctly initialized.
 ///
 /// Usage:
 /// ```dart
 /// UseCaseProvider().initialize();
 /// ```
 void initialize() {
  timerUseCases = TimerUseCases(TimerRepositoryImpl());
 }
}
