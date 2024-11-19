// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FiltrosWidget extends StatefulWidget {
  final String name;

  FiltrosWidget({required this.name});

  @override
  _FiltrosWidgetState createState() => _FiltrosWidgetState();
}

class _FiltrosWidgetState extends State<FiltrosWidget> {
  double _currentSliderValue = 200;
  List<bool> _isPressed = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 252, 247),
        title: Text(
          widget.name,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Color.fromARGB(255, 144, 238, 96),
              size: 42,
            ),
            tooltip: 'Show Snackbar',
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: const Color.fromARGB(255, 144, 238, 96),
            height: 4.0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: 20.0,
            left: 30.0,
            bottom: 20.0,
            right: 20.0), // Added right padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Distância",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
            Slider(
              value: _currentSliderValue,
              min: 200,
              max: 5000,
              divisions: 24,
              label: _currentSliderValue.round().toString(),
              activeColor: Color.fromARGB(255, 144, 238, 96),
              inactiveColor: Color.fromARGB(255, 144, 238, 96),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text("Restrições Alimentares",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(0, 'Vegetariano'),
                    SizedBox(width: 10),
                    _buildButton(1, 'Sem Gluten'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(2, 'Halal'),
                    SizedBox(width: 10),
                    _buildButton(3, 'Vegan'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(4, 'Sem Lactose'),
                    SizedBox(width: 10),
                    _buildButton(5, 'Kosher'),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Text("Tipo de Estabelecimento",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(6, 'Padaria'),
                SizedBox(width: 10),
                _buildButton(7, 'Pastelaria'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(8, 'Restaurante'),
                SizedBox(width: 10),
                _buildButton(9, 'Mercearia'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(int index, String buttonText) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20.0, left: 0.0, right: 10),
        child: Container(
          width: 150, // Set the width of the button
          height: 50, // Set the height of the button
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isPressed[index] = !_isPressed[index];
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: _isPressed[index] ? Colors.white : Colors.black,
              backgroundColor: _isPressed[index]
                  ? Color.fromARGB(255, 144, 238, 96)
                  : Color(0xFFEFCF7),
              side: BorderSide(color: Color.fromARGB(255, 144, 238, 96)),
            ),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
