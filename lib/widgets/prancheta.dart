// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class prancheta extends StatefulWidget {
  final String businessUid;
  final void Function({required String businessUid, required int count})
      updateBusinessDishCount;

  const prancheta(
      {super.key,
      required this.businessUid,
      required this.updateBusinessDishCount});

  @override
  _PranchetaState createState() => _PranchetaState();
}

class _PranchetaState extends State<prancheta> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10), // Reduced padding
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(20, 20), // Reduced button size
              backgroundColor: Color(0xFF90EE60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), // Reduced radius
                  bottomLeft: Radius.circular(10), // Reduced radius
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                value++;
                widget.updateBusinessDishCount(
                    businessUid: widget.businessUid, count: value);
              });
            },
            child: Text('+',
                style: TextStyle(
                    fontSize: 20, // Reduced font size
                    color: const Color.fromARGB(255, 254, 252, 247))),
          ),
        ),
        Text(
          '$value',
          style: TextStyle(fontSize: 15), // Reduced font size
        ),
        Padding(
          padding: EdgeInsets.only(left: 10), // Reduced padding
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(20, 20), // Reduced button size
              backgroundColor: Color(0xFF90EE60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), // Reduced radius
                  bottomRight: Radius.circular(10), // Reduced radius
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                if (value != 0) {
                  value--;
                }
                widget.updateBusinessDishCount(
                    businessUid: widget.businessUid, count: value);
              });
            },
            child: Text('-',
                style: TextStyle(
                    fontSize: 20, // Reduced font size
                    color: const Color.fromARGB(255, 254, 252, 247))),
          ),
        ),
      ],
    );
  }
}
