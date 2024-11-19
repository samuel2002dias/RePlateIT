import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/pages/Home/home.dart';
import 'package:main/pages/Navigation/Business/Profile/editar_perfil.dart';
import 'package:main/pages/Navigation/Business/Profile/perguntas_frequentes.dart';
import 'package:main/pages/Navigation/Business/Profile/politica_privacidade.dart';
import 'package:main/pages/Navigation/Business/Profile/sobre.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';

class BusinessProfile extends StatefulWidget {
  const BusinessProfile({
    super.key,
  });

  @override
  State<BusinessProfile> createState() => _PerfilState();
}

class _PerfilState extends State<BusinessProfile> {
  final Stream<DocumentSnapshot<Object?>> _businessStream =
      FirestoreService(uid: Auth().currentUser()!.uid).getUserSnapshot();

  final Stream<String> _businessImageStream =
      StorageService().getBusinessImage(uid: Auth().currentUser()!.uid);

  void goToEditProfilePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BusinessProfileEdit(),
      ),
    );
  }

  void goToAboutPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BusinessSobre(),
      ),
    );
  }

  void goToPoliticyPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BusinessPoliticaPrivacidade(),
      ),
    );
  }

  void goToHelpPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BusinessPerguntasFrequentes(),
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
        stream: _businessStream,
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
            stream: _businessImageStream,
            builder: (context, userImageSnapshot) {
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
                                  'A carregar imagem do restaurante',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              LinearProgressIndicator(
                                value: 0.75,
                                semanticsLabel:
                                    'A carregar imagem do restaurante',
                              ),
                            ],
                          ),
                        ),
                  Text(
                    GetSnapshotData().getUserField(
                        snapshotData: userSnapshot.data,
                        fieldName: "business_name"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    GetSnapshotData().getUserField(
                        snapshotData: userSnapshot.data, fieldName: "phone"),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
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
                        // rgb(77, 72, 64)
                        color: Color.fromARGB(
                          255,
                          77,
                          72,
                          64,
                        ),
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: goToHelpPage,
                            child: const Text(
                              "Perguntas frequentes",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: goToAboutPage,
                            child: const Text(
                              "Sobre",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: goToPoliticyPage,
                            child: const Text(
                              "Política de privacidade",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: handleSignOut,
                            child: const Text(
                              "Terminar sessão",
                              style: TextStyle(
                                color: Colors.white,
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
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "support@replateit.pt",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
