import 'package:flutter/material.dart';
import 'package:main/core/constantes.dart';

class BusinessPoliticaPrivacidade extends StatelessWidget {
  const BusinessPoliticaPrivacidade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 252, 247),
        title: const Text("Politica de Privacidade"),
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
      body: const Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    politicaprivacidade,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        color: Colors.black),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}