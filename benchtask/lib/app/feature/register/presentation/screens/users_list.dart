import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_bloc.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_event.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_state.dart';
import 'package:benchtask/app/feature/register/presentation/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/user_list_widget.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().add(GetAllUserEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("User List"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Register(isEdit: false),
              ),
            );
          },
        ),
        body: BlocBuilder<UserBloc, UserState>(
          buildWhen: (previousState, currentState) {
            // Rebuild only when the user list changes (i.e., RegistrationSuccess state)

            if (currentState is RegistrationSuccess && previousState is RegistrationSuccess) {

              return previousState.users != currentState.users;
            }
            // Rebuild when transitioning from loading or error to success
            return currentState is RegistrationSuccess;
          },
          builder: (context, state) {
            if (state is RegistrationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RegistrationError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is RegistrationSuccess) {
              if (state.users.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = state.users[index];
                    return UserCard(
                      userName: user.name,
                      age: user.age,
                      userEmail: user.email,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(
                              isEdit: true,
                              user: user, // Pass the user directly
                            ),
                          ),
                        );
                      },
                      onDelete: () {
                        context.read<UserBloc>().add(DeleteUserEvent(user));
                      },
                    );
                  },
                );
              } else {
                return const Center(child: Text("No Data Found"));
              }
            }
            return const Center(child: Text("No Data Found")); // Default case
          },
        ),
      ),
    );
  }
}
