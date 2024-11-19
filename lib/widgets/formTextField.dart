import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    Key? key,
    required this.label,
    required this.callbackFunction,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.labelTextColor = Colors.black54, // Default color
    this.contentPadding = EdgeInsets.zero, // Default content padding
  }) : super(key: key);

  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String) callbackFunction;
  final Color labelTextColor;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: callbackFunction,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        labelStyle: TextStyle(
          color: labelTextColor,
          fontFamily: 'Nunito',
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 148, 248, 102),
            width: 2.0,
          ),
        ),
        focusColor: const Color.fromARGB(255, 148, 248, 102),
        contentPadding: contentPadding,
      ),
    );
  }
}


