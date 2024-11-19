import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:main/widgets/FormPratos.dart';

class Reservas extends StatefulWidget {
  const Reservas({
    super.key,
  });

  @override
  State<Reservas> createState() => _ReservasState();
}

class _ReservasState extends State<Reservas> {
  final Stream<QuerySnapshot<Object?>> _reservations =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "").getReservations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      body: StreamBuilder(
        stream: _reservations,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao obter reservas"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("A carregar reservas"),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reservas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 31.0,
                    fontFamily: 'Nunito',
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map(
                      (
                        r,
                      ) {
                        final Stream<DocumentSnapshot<Object?>> dishData =
                            FirestoreService(
                          uid: Auth().currentUser()?.uid ?? "",
                        ).getDishSnapshot(
                          targetUid: GetSnapshotData().getUserField(
                            snapshotData: r,
                            fieldName: "dish_uid",
                          ),
                        );

                        return StreamBuilder(
                          stream: dishData,
                          builder: (businessContext, dishDataSnapshot) {
                            if (!dishDataSnapshot.hasData) {
                              return const Center(
                                child: Text(
                                  "A carregar prato...",
                                ),
                              );
                            }

                            if (dishDataSnapshot.hasError) {
                              return const Center(
                                child: Text(
                                  "Erro ao carregar prato",
                                ),
                              );
                            }

                            Stream<String> getDishImage =
                                StorageService().getDishImage(
                              uid: GetSnapshotData().getUserField(
                                snapshotData: r,
                                fieldName: "dish_uid",
                              ),
                            );

                            return StreamBuilder(
                              stream: getDishImage,
                              builder: (context, imageSnapshot) {
                                if (!imageSnapshot.hasData) {
                                  return const Center(
                                    child:
                                        Text("A carregar imagem do prato..."),
                                  );
                                }

                                return Pratos(
                                  showPortions: false,
                                  image: imageSnapshot.data ?? "",
                                  nome_prato: GetSnapshotData().getUserField(
                                      snapshotData: dishDataSnapshot.data,
                                      fieldName: "name"),
                                  nr_doses: int.parse(
                                    GetSnapshotData().getUserField(
                                        snapshotData: dishDataSnapshot.data,
                                        fieldName: "num_of_portion"),
                                  ),
                                  index: r.id,
                                );
                              },
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
