import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_bloc.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterButton extends StatefulWidget {
  final GlobalKey<FormState> formKey; // Accepting the form key
  final User userdata;

  const RegisterButton({super.key, required this.formKey,required this.userdata}); // Make formKey required

  @override
  State<RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Validate the form using the formKey
        if (widget.formKey.currentState?.validate() ?? false) {
        context.read<UserBloc>().add(CreateUserEvent(user: widget.userdata));
        Navigator.pop(context);
        }
      },
      child: const Text('Register'),
    );
  }
}
