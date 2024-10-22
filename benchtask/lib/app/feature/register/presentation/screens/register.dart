import 'package:benchtask/app/feature/register/domain/entities/user.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_bloc.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_event.dart';
import 'package:benchtask/app/feature/register/presentation/bloc/user_state.dart';
import 'package:benchtask/app/feature/register/presentation/widgets/button_widget.dart';
import 'package:benchtask/app/feature/register/presentation/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class Register extends StatefulWidget {
  final bool isEdit;
  final User? user;
  const Register({required this.isEdit, this.user,super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>(); // Key for the form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  var id="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEdit){
      _nameController.text=widget.user!.name;
      _emailController.text=widget.user!.email;
      _ageController.text=widget.user!.age;
      _addressController.text=widget.user!.address;
      _pinCodeController.text=widget.user!.pinCode;
      id=widget.user!.id.toString();
    }

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      "New Register",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    TextfieldWidget(
                      controller: _nameController,
                      hintText: 'Name',
                      validator: (value) => _nameValidator(value),
                    ),
                    const SizedBox(height: 20), // Add space between TextFields
                    TextfieldWidget(
                      controller: _ageController,
                      hintText: 'Age',
                      validator: (value) => _ageValidator(value!),
                    ),
                    const SizedBox(height: 20), // Add space between TextFields
                    TextfieldWidget(
                        controller: _emailController,
                        hintText: 'Email',
                        validator: (value) => _emailValidator(value!)),
                    const SizedBox(height: 20), // Add space between TextFields
                    TextfieldWidget(
                        controller: _addressController,
                        hintText: 'Address',
                        validator: (value) => _addressValidator(value)),
                    const SizedBox(height: 20), // Add space between TextFields
                    TextfieldWidget(
                        controller: _pinCodeController,
                        hintText: 'Pin Code',
                        validator: (value) => _pinCodeValidator(value)),
                    const SizedBox(height: 20),

                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is RegistrationLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return RegisterButton(
                          formKey: _formKey,
                          userdata: User(
                              id: (!widget.isEdit)?const Uuid().v4():id,
                              name: _nameController.text,
                              email: _emailController.text,
                              address: _addressController.text,
                              age: _ageController.text,
                              pinCode: _pinCodeController.text),
                        ); // Default case
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _ageValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter your age';
    } else if (int.tryParse(value) == null || int.parse(value) > 120 || int.parse(value) < 0) {
      return 'Please enter a valid age';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? _pinCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your pin code';
    }
    return null;
  }
}
