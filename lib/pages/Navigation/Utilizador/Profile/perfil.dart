import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/pages/Home/home.dart';
import 'package:main/pages/Navigation/Utilizador/Profile/editar_perfil.dart';
import 'package:main/pages/Navigation/Utilizador/Profile/perguntas_frequentes.dart';
import 'package:main/pages/Navigation/Utilizador/Profile/politica_privacidade.dart';
import 'package:main/pages/Navigation/Utilizador/Profile/sobre.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';

class Perfil extends StatefulWidget {
  const Perfil({
    super.key,
  });

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final Stream<DocumentSnapshot<Object?>> _userStream =
      FirestoreService(uid: Auth().currentUser()!.uid).getUserSnapshot();

  final Stream<String> _userImageStream =
      StorageService().getUserImage(uid: Auth().currentUser()!.uid);

  void goToEditProfilePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditarPerfil(),
      ),
    );
  }

  void goToAboutPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Sobre(),
      ),
    );
  }

  void goToPoliticyPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PoliticaPrivacidade(),
      ),
    );
  }

  void goToHelpPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PerguntasFrequentes(),
      ),
    );
  }

  void handleSignOut() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
    Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _userStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(
              value: 0.25,
              semanticsLabel: 'A carregar dados do utilizador',
            );
          }

          return StreamBuilder(
            stream: _userImageStream,
            builder: (context, userImageSnapshot) {
              // if (!userImageSnapshot.hasData) {
              //   return const Padding(
              //     padding: EdgeInsets.only(left: 50, right: 50),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: EdgeInsets.only(bottom: 20),
              //           child: Text(
              //             'A carregar imagem do utilizador',
              //             style: TextStyle(fontSize: 20),
              //           ),
              //         ),
              //         LinearProgressIndicator(
              //           value: 0.75,
              //           semanticsLabel: 'A carregar imagem do utilizador',
              //         ),
              //       ],
              //     ),
              //   );
              // }

              return Column(
                children: [
                  userImageSnapshot.hasData
                      ? Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              userImageSnapshot.data ?? "",
                            ),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(
                              top: 20, left: 50, right: 50, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  'A carregar imagem do utilizador',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              LinearProgressIndicator(
                                value: 0.75,
                                semanticsLabel:
                                    'A carregar imagem do utilizador',
                              ),
                            ],
                          ),
                        ),
                  Text(
                    GetSnapshotData().getUserField(
                        snapshotData: userSnapshot.data, fieldName: "name"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      GetSnapshotData().getUserField(
                          snapshotData: userSnapshot.data,
                          fieldName: "location",
                          fallbackString: "Nenhuma localização definida"),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    GetSnapshotData().getUserField(
                        snapshotData: userSnapshot.data, fieldName: "phone"),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: Offset(0, 3)),
                        ]),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: goToEditProfilePage,
                            child: const Text(
                              "Editar perfil",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: goToHelpPage,
                            child: const Text(
                              "Perguntas frequentes",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: goToAboutPage,
                            child: const Text(
                              "Sobre",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: goToPoliticyPage,
                            child: const Text(
                              "Política de privacidade",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: handleSignOut,
                            child: const Text(
                              "Terminar sessão",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Linha de apoio: 275 123 456",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                          ),
                          Text(
                            "support@replateit.pt",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
