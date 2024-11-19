import 'package:flutter/material.dart';
import 'package:main/pages/Home/Auth/Register/User/pick_user_avatar.dart';
import 'package:main/widgets/formTextField.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
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

  bool isCheckboxChecked = false;
  String _username = "";
  String _email = "";
  String _phoneNumber = "";
  String _password = "";
  String _confirmPassword = "";

  void _handleUpdateUsername(String value) {
    setState(() => _username = value);
  }

  void _handleUpdateEmail(String value) {
    setState(() => _email = value);
  }

  void _handleUpdatePhoneNumber(String value) {
    setState(() => _phoneNumber = value);
  }

  void _handleUpdatePassword(String value) {
    setState(() => _password = value);
  }

  void _handleUpdateConfirmPassword(String value) {
    setState(() => _confirmPassword = value);
  }

  void registerUser() {
    if (!isCheckboxChecked) {
      showSnackbar(
          message: "Tem de aceitar a política de privacidade.",
          color: Colors.red);
      return;
    }

    if (_password != _confirmPassword) {
      showSnackbar(message: "Passwords não coincidem", color: Colors.red);
      return;
    }

    if (_username.isEmpty || _email.isEmpty || _phoneNumber.isEmpty) {
      showSnackbar(message: "Preencha todos os campos", color: Colors.red);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PickUserAvatar(
          username: _username,
          email: _email,
          phoneNumber: _phoneNumber,
          password: _password,
        ),
      ),
    );
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
                width: 315,
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                      child: Text(
                        'Criar conta',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                    AuthTextField(
                      label: "Nome do utilizador",
                      callbackFunction: _handleUpdateUsername,
                    ),
                    AuthTextField(
                      label: "Endereço de email",
                      callbackFunction: _handleUpdateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AuthTextField(
                      label: "Número de telefone",
                      callbackFunction: _handleUpdatePhoneNumber,
                      keyboardType: TextInputType.phone,
                    ),
                    AuthTextField(
                      label: "Palavra-passe",
                      callbackFunction: _handleUpdatePassword,
                      obscureText: true,
                    ),
                    AuthTextField(
                      label: "Confirmar a palavra-passe",
                      callbackFunction: _handleUpdateConfirmPassword,
                      obscureText: true,
                    ),
                    Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isCheckboxChecked,
                                activeColor:
                                    const Color.fromRGBO(148, 248, 102, 1),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                  ),
                                ),
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() => isCheckboxChecked = value);
                                  }
                                },
                              ),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Li e Concordo com a ',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontFamily: 'Nunito',
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Política de \nPrivacidade',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontFamily: 'Nunito',
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: registerUser,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(148, 248, 102, 1),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0))),
                              child: const Text(
                                'Seguinte',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey,
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text(
                                "Voltar atrás",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                        ],
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