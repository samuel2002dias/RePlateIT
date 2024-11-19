// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:main/widgets/botao_horas.dart';
import 'package:main/widgets/estabelecimentos_botao.dart';
import 'package:main/widgets/prancheta.dart';

class Reservar extends StatefulWidget {
  final Botao botao;

  const Reservar({Key? key, required this.botao}) : super(key: key);

  @override
  State<Reservar> createState() => _ReservarState();
}

class _ReservarState extends State<Reservar> {
  @override
  Widget build(BuildContext context) {
    return ReservarPage(botao: widget.botao);
  }
}

class ReservarPage extends StatelessWidget {
  final Botao botao;

  ReservarPage({required this.botao});

  late final Stream<QuerySnapshot<Object?>> _allBusinessDishes =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
          .getBusinessDishes(businessUid: botao.businessUid);

  final List<String> businessArray = [];

  void updateBusinessDishCount(
      {required String businessUid, required int count}) {
    if (count > 0) {
      if (!businessArray.contains(businessUid)) {
        businessArray.add(businessUid);
      }
    } else {
      businessArray.remove(businessUid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 252, 247),
        title: Text(
          botao.name,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
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
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, bottom: 20.0),
            child: Text("Doses Disponiveis",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ),
          StreamBuilder(
            stream: _allBusinessDishes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("A carregar estabelecimento..."),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((e) {
                  Stream<String> getDishImage =
                      StorageService().getDishImage(uid: e.id);

                  return StreamBuilder(
                    stream: getDishImage,
                    builder: (context, imageSnapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text("A carregar imagem do prato..."),
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                  GetSnapshotData().getUserField(
                                      snapshotData: e, fieldName: "name"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: prancheta(
                              updateBusinessDishCount: updateBusinessDishCount,
                              businessUid: e.id,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
          // pratos(),
          Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 10.0, top: 20.0),
            child: Text("Horas Disponiveis",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 200.0,
              left: 20.0,
              right: 10.0,
            ),
            child: ButtonGroup(
              buttons: [
                "22:30 - 23:00",
                "23:00 - 23:30",
                "23:30 - 00:00",
                "00:00 - 00:30",
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: 130,
              child: ElevatedButton(
                onPressed: () {
                  if (businessArray.isNotEmpty) {
                    for (var e in businessArray) {
                      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
                          .addReservation(dishUid: e);
                    }
                  }
                }, // Criar Reserva na BD
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
                  'Confirmar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
