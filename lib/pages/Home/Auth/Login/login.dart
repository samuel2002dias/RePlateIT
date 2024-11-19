import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/pages/Navigation/Business/navegacao.dart';
import 'package:main/pages/Navigation/Utilizador/navegacao.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/widgets/formTextField.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = "";
  String _password = "";

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

  void _handleUpdateEmail(String newValue) => setState(() => _email = newValue);

  void _handleUpdatePassword(String newValue) =>
      setState(() => _password = newValue);

  void goToMainPage(isBusiness) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isBusiness ? const NavegacaoBusiness() : const Navegacao(),
      ),
      (route) => false);

  void signIn() async {
    if (_email.isEmpty || _password.isEmpty) {
      showSnackbar(message: "Preencha todos os campos", color: Colors.red);
      return;
    }

    try {
      UserCredential credential =
          await Auth().signIn(email: _email, password: _password);

      if (credential.user!.uid.isEmpty) {
        showSnackbar(message: "Credenciais erradas", color: Colors.red);
        return;
      }

      DocumentSnapshot<Object?> userData =
          await FirestoreService(uid: credential.user?.uid ?? "").getUserData();

      bool isBusiness = GetSnapshotData()
          .getUserField(snapshotData: userData, fieldName: "business");

      goToMainPage(isBusiness);
      // showSnackbar(message: "Sessão iniciada com sucesso");
    } on FirebaseAuthException catch (e) {
      showSnackbar(
        message: e.message ?? "Erro ao iniciar sessão",
        color: Colors.red,
      );
    }
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
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                      child: Text(
                        'Já tenho conta',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontFamily: 'Nunito'),
                      ),
                    ),
                    AuthTextField(
                      label: "Endereço de e-mail",
                      callbackFunction: _handleUpdateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AuthTextField(
                      label: "Palavra-Passe",
                      callbackFunction: _handleUpdatePassword,
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 200, 20, 0),
                      child: ElevatedButton(
                        onPressed: signIn,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(148, 248, 102, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black54,
                          side: const BorderSide(
                            color: Colors.transparent,
                          )),
                      onPressed: () => {
                        if (Navigator.canPop(context))
                          {
                            Navigator.pop(context),
                          }
                      },
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
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 60, 50, 0),
                child: Text(
                  "Linha de Apoio: 275 123 456",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Text(
                  "support@RePlateIt.pt",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Nunito',
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
