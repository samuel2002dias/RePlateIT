// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class ButtonGroup extends StatefulWidget {
  final List<String> buttons;

  ButtonGroup({required this.buttons});

  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> {
  String _selectedButton = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.buttons.take(2).map((text) {
            return BotaoHoras(
              text: text,
              isSelected: _selectedButton == text,
              onPressed: () {
                setState(() {
                  _selectedButton = text;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10), // Add 10 pixels of spacing between the rows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.buttons.skip(2).map((text) {
            return BotaoHoras(
              text: text,
              isSelected: _selectedButton == text,
              onPressed: () {
                setState(() {
                  _selectedButton = text;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class BotaoHoras extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  BotaoHoras(
      {required this.text, required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (isSelected)
              return Colors.white; // Text color when button is pressed
            return Color(0xFF90EE60); // Text color when button is not pressed
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (isSelected)
              return Color(
                  0xFF90EE60); // Background color when button is pressed
            return Colors
                .transparent; // Background color when button is not pressed
          },
        ),
        side: MaterialStateProperty.all(BorderSide(color: Color(0xFF90EE60))),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Adjust for rounded corners
        )),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0), // Adjust padding to match the size in the image
        child: Text(text,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600)), // Adjust font size as needed
      ),
    );
  }
}
