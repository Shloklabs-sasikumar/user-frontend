import 'package:benchtask/app/core/local_db/local_db_impl.dart';
import 'package:benchtask/app/core/local_db/local_db_storage_utils.dart';
import 'package:benchtask/app/core/use_case_injection/use_case_injection.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/theme_cubit.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_bloc.dart';
import 'package:benchtask/app/feature/register/presentation/screens/users_list.dart';
import 'package:benchtask/app/feature/timer/infrastructure/repositories_impl/timer_repository_impl.dart';
import 'package:benchtask/app/feature/timer/presentation/bloc/timer_bloc.dart';
import 'package:benchtask/app/feature/timer/presentation/screens/timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use cases injection
  UseCaseProvider().initialize();
  LocalStorageUtility().init(LocalStorageImpl());
  runApp(const LaunchScreen());
}

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    UseCaseProvider useCasedependencies = UseCaseProvider();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<UserBloc>(
            create: (context) => UserBloc(
                  useCasedependencies.userUseCases,
                )),
        BlocProvider<TimerBloc>(
            create: (context) => TimerBloc(
              useCasedependencies.timerUseCases,
            )),
      ],
      child: MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 24.0, // Adjust size as needed
              fontWeight: FontWeight.bold,
              color: Colors.black, // Adjust color as needed
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home:  TimerScreen(),
      ),
    );
  }
}
