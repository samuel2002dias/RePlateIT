import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/pages/Home/home.dart';
import 'package:main/pages/Navigation/Business/navegacao.dart';
import 'package:main/pages/Navigation/Utilizador/navegacao.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          final Stream<DocumentSnapshot<Object?>> userData =
              FirestoreService(uid: Auth().currentUser()!.uid)
                  .getUserSnapshot();

          return StreamBuilder(
              stream: userData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                      body: Center(
                    child: Text("A carregar perfil..."),
                  ));
                }

                bool isBusiness = GetSnapshotData().getUserField(
                    snapshotData: snapshot.data, fieldName: "business");

                return isBusiness
                    ? const NavegacaoBusiness()
                    : const Navegacao();
              });
        }

        return const Home();
      },
    );
  }
}
