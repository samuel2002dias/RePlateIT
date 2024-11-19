import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:main/widgets/formTextField.dart';

class BusinessProfileEdit extends StatefulWidget {
  const BusinessProfileEdit({
    super.key,
  });

  @override
  State<BusinessProfileEdit> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<BusinessProfileEdit> {
  File? selectedImage;
  String _username = "";
  String _location = "";
  String _phoneNumber = "";
  // String _password = "";

  void goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> updateProfile() async {
    String uid = Auth().currentUser()?.uid ?? "";

    if (uid.isEmpty) {
      return;
    }

    FirestoreService firestore = FirestoreService(uid: uid);

    await firestore.updateBusinessName(_username);
    await firestore.updateUserLocation(_location);
    await firestore.updateUserPhoneNumber(_phoneNumber);
    if (selectedImage != null) {
      await StorageService()
          .uploadBusinessImage(file: selectedImage!, uid: uid);
    }

    goBack();
  }

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

  void updateUsername(String newName) {
    setState(() {
      _username = newName;
    });
  }

  void updateLocation(String newLocation) {
    setState(() {
      _location = newLocation;
    });
  }

  void updatePhoneNumber(String newPhoneNumber) {
    setState(() {
      _phoneNumber = newPhoneNumber;
    });
  }

  void updatePassword(String newPassword) {
    setState(() {
      // _password = newPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 252, 247),
        title: const Text("Editar Perfil"),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  pickImageGallary();
                },
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: const Color.fromRGBO(148, 248, 102, 1),
                  child: CircleAvatar(
                    radius: 62,
                    backgroundColor: Colors.white,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : null,
                    child: selectedImage == null
                        ? const Text(
                            "Alterar",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Nunito',
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                child: Column(
                  children: [
                    AuthTextField(
                      label: "Nome do utilizador",
                      callbackFunction: updateUsername,
                    ),
                    AuthTextField(
                      label: "Localização",
                      callbackFunction: updateLocation,
                    ),
                    AuthTextField(
                      label: "Número de telemóvel",
                      keyboardType: TextInputType.phone,
                      callbackFunction: updatePhoneNumber,
                    ),
                    AuthTextField(
                      label: "Palavra-passe",
                      callbackFunction: updatePassword,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(148, 248, 102, 1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Text(
                            'Concluir',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
