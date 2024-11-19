import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:main/widgets/estabelecimentos_botao.dart';

class Favourites extends StatefulWidget {
  const Favourites({
    super.key,
  });

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final Stream<QuerySnapshot<Object?>> _favorites =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
          .getUserFavoritesSnapshot();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      body: StreamBuilder(
        stream: _favorites,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao obter favoritos"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("A carregar favoritos"),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Favoritos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 31.0,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map(
                      (
                        favoritesInfo,
                      ) {
                        final Stream<DocumentSnapshot<Object?>> businessInfo =
                            FirestoreService(
                          uid: Auth().currentUser()?.uid ?? "",
                        ).getUserSnapshot(
                          targetUid: GetSnapshotData().getUserField(
                            snapshotData: favoritesInfo,
                            fieldName: "business_uid",
                          ),
                        );

                        return StreamBuilder(
                          stream: businessInfo,
                          builder: (businessContext, businessSnapshot) {
                            if (!businessSnapshot.hasData) {
                              return const Center(
                                child: Text(
                                  "A carregar estabelecimento",
                                ),
                              );
                            }

                            if (businessSnapshot.hasError) {
                              return const Center(
                                child: Text(
                                  "Erro ao carregar estabelecimento",
                                ),
                              );
                            }

                            final Stream<String> businessImageStream =
                                StorageService().getBusinessImage(
                              uid: GetSnapshotData().getUserField(
                                snapshotData: favoritesInfo,
                                fieldName: "business_uid",
                              ),
                            );

                            return StreamBuilder(
                              stream: businessImageStream,
                              builder: (context, businessImageSnapshot) {
                                return Botao(
                                  businessUid: GetSnapshotData().getUserField(
                                    snapshotData: favoritesInfo,
                                    fieldName: "business_uid",
                                  ),
                                  image: businessImageSnapshot.data ?? "",
                                  name: GetSnapshotData().getUserField(
                                    snapshotData: businessSnapshot.data,
                                    fieldName: "business_name",
                                  ),
                                  type: GetSnapshotData().getUserField(
                                    snapshotData: businessSnapshot.data,
                                    fieldName: "type",
                                  ),
                                  localization: GetSnapshotData().getUserField(
                                    snapshotData: businessSnapshot.data,
                                    fieldName: "address",
                                  ),
                                  isFavorite: true,
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
