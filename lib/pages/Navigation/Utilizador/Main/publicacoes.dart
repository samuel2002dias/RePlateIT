// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:main/widgets/FormPratos.dart';
import 'package:main/pages/Navigation/Utilizador/Reservations/realizar_reservas.dart';

import 'package:main/widgets/estabelecimentos_botao.dart';

class Publicacoes extends StatefulWidget {
  final Botao botao;
  const Publicacoes({Key? key, required this.botao}) : super(key: key);

  @override
  State<Publicacoes> createState() => _PublicacoesState();
}

class _PublicacoesState extends State<Publicacoes> {
  @override
  Widget build(BuildContext context) {
    return PublicacoesPage(botao: widget.botao);
  }
}

class PublicacoesPage extends StatelessWidget {
  final Botao botao;
  PublicacoesPage({required this.botao});

  late final Stream<QuerySnapshot<Object?>> _allBusinessDishes =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
          .getBusinessDishes(businessUid: botao.businessUid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Publicações",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 140.0),
                    child: IconButton(
                      icon: Icon(Icons.close,
                          size: 35.0, color: Color(0xFF90EE60)),
                      onPressed: () {
                        print("BOTAO FECHAR");
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              Divider(color: Color(0xFF90EE60), thickness: 3.0),
              StreamBuilder(
                stream: _allBusinessDishes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("A carregar estabelecimento..."),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("Não existem pratos..."),
                    );
                  }

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Stream<String> getDishImage = StorageService()
                          .getDishImage(uid: snapshot.data!.docs[index].id);

                      return StreamBuilder(
                        stream: getDishImage,
                        builder: (context, imageSnapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text("A carregar imagem do prato..."),
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, right: 15.0, bottom: 10.0),
                            child: Pratos(
                              image: imageSnapshot.data ?? "",
                              nome_prato: GetSnapshotData().getUserField(
                                  snapshotData: snapshot.data!.docs[index],
                                  fieldName: "name"),
                              nr_doses: int.parse(
                                GetSnapshotData().getUserField(
                                    snapshotData: snapshot.data!.docs[index],
                                    fieldName: "num_of_portion"),
                              ),
                              index: snapshot.data!.docs[index].id,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              // ListPratos(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Reservar(
                              botao: botao,
                            )),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF90EE60)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                child: Text(
                  'Reservar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
