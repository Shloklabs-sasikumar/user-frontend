
import 'package:flutter/material.dart';

class TextfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  const TextfieldWidget(
  {super.key, required this.controller,required this.hintText,required this.validator});

  @override
  State<TextfieldWidget> createState() => _TextfieldWidgetState();
}

class _TextfieldWidgetState extends State<TextfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:widget.controller ,
      decoration: InputDecoration(
        hintText: widget.hintText, // Use the hint text from the widget
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Default border
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0), // Focused border
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0), // Error border
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0), // Focused error border
        ),
      ),
      validator:widget.validator,

    );
  }
}
