import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main/pages/Navigation/Business/navegacao.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';

class PickBusinessImage extends StatefulWidget {
  const PickBusinessImage(
      {super.key,
      required this.businessName,
      required this.email,
      required this.phoneNumber,
      required this.address,
      required this.password});

  final String businessName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  @override
  State<PickBusinessImage> createState() => _PickBusinessImageState();
}

class _PickBusinessImageState extends State<PickBusinessImage> {
  void showSnackbar({
    required String message,
    Color? color = Colors.green,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }

  void goToMainPage() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavegacaoBusiness(),
        ),
      );

  void registerBusiness() async {
    try {
      if (selectedImage == null) {
        showSnackbar(message: "Deve selecionar uma imagem", color: Colors.red);
        return;
      }

      UserCredential credential =
          await Auth().register(email: widget.email, password: widget.password);

      if (credential.user?.uid == null) {
        showSnackbar(
            message: "Erro ao registar o utilizador.", color: Colors.red);
        return;
      }

      await FirestoreService(uid: credential.user!.uid).setBusinessData(
          name: widget.businessName,
          phone: widget.phoneNumber,
          address: widget.address);

      await StorageService()
          .uploadBusinessImage(file: selectedImage!, uid: credential.user!.uid);

      goToMainPage();
    } on FirebaseAuthException catch (e) {
      showSnackbar(message: e.message ?? "", color: Colors.red);
    }
  }

  File? selectedImage;

  Future<void> pickImageGallary() async {
    final ImagePicker picker = ImagePicker();
    final returnedImage = await picker.pickImage(source: ImageSource.gallery);
    if (returnedImage == null) {
      return;
    }
    setState(
      () {
        selectedImage = File(returnedImage.path);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 320,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 80, 20, 50),
                      child: Center(
                        child: Text(
                          "Adicione uma imagem",
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 28,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                      child: GestureDetector(
                        onTap: () {
                          pickImageGallary();
                        },
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor:
                              const Color.fromRGBO(148, 248, 102, 1),
                          child: CircleAvatar(
                            radius: 63,
                            backgroundColor: Colors.white,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : null,
                            child: selectedImage == null
                                ? const Text(
                                    "Adicionar",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 4, 20, 80),
                      child: Text(
                        "Irá ajudar a que reconheçam o seu \nestabelecimento!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Nunito',
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: ElevatedButton(
                        onPressed: registerBusiness,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(148, 248, 102, 1),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Criar Conta',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.transparent,
                          )),
                      onPressed: () => {Navigator.pop(context)},
                      child: const Text(
                        "Voltar atrás",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
