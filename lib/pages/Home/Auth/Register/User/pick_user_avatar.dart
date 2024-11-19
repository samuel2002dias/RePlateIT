import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:main/pages/Navigation/Utilizador/navegacao.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:path_provider/path_provider.dart';

class PickUserAvatar extends StatefulWidget {
  const PickUserAvatar(
      {super.key,
      required this.username,
      required this.email,
      required this.phoneNumber,
      required this.password});

  final String username;
  final String email;
  final String phoneNumber;
  final String password;

  @override
  State<PickUserAvatar> createState() => _PickUserAvatarState();
}

class _PickUserAvatarState extends State<PickUserAvatar> {
  int _selectedAvatarIndex = -1;
  File? _selectedImage;

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
          builder: (context) => const Navegacao(),
        ),
      );

  void register() async {
    try {
      UserCredential credential =
          await Auth().register(email: widget.email, password: widget.password);

      if (credential.user?.uid == null) {
        showSnackbar(message: "Erro ao registar o utilizador.");
        return;
      }

      await FirestoreService(uid: credential.user!.uid)
          .setUserData(name: widget.username, phone: widget.phoneNumber);

      if (_selectedAvatarIndex != -1) {
        // Image  avatarImg = Image(image: AssetImage("images/avatars/avatar$_selectedAvatarIndex.png"));
        final byteData = await rootBundle
            .load('images/avatars/avatar$_selectedAvatarIndex.png');
        final avatar =
            File('${(await getTemporaryDirectory()).path}/avatar.png');
        await avatar.writeAsBytes(byteData.buffer.asUint8List());

        await StorageService()
            .uploadUserImage(file: avatar, uid: credential.user!.uid);

        goToMainPage();
      } else {
        await StorageService()
            .uploadUserImage(file: _selectedImage!, uid: credential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(message: e.message ?? "", color: Colors.red);
    }
  }

  Future<void> _pickImageGallary() async {
    _selectedAvatarIndex = -1;

    final ImagePicker picker = ImagePicker();
    final XFile? returnedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (returnedImage == null) {
      return;
    }
    setState(
      () {
        _selectedImage = File(returnedImage.path);
      },
    );
  }

  void _handleUpdateAvatar(int index) {
    _selectedImage = null;

    setState(() {
      if (_selectedAvatarIndex == index) {
        _selectedAvatarIndex = -1;
      } else {
        _selectedAvatarIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 80, 20, 40),
                      child: Text(
                        'Selecione um avatar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 29,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => _handleUpdateAvatar(index),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: _selectedAvatarIndex == index
                                    ? const Color.fromRGBO(148, 248, 102, 1)
                                    : Colors.white,
                                child: CircleAvatar(
                                  radius: 37,
                                  backgroundImage: AssetImage(
                                      "images/avatars/avatar$index.png"),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, 20, 20, _selectedImage != null ? 0 : 80),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: const BorderSide(
                              color: Colors.transparent,
                            )),
                        onPressed: _pickImageGallary,
                        child: const Text(
                          "Quero adicionar uma foto",
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ),
                    _selectedImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_selectedImage!))
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(148, 248, 102, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0))),
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
                          foregroundColor: Colors.grey,
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
