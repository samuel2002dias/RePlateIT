// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:main/widgets/estabelecimentos_botao.dart';
import 'package:main/widgets/business_search_bar.dart';

class ListaEstabelecimentos extends StatefulWidget {
  const ListaEstabelecimentos({
    super.key,
  });

  @override
  _ListaEstabelecimentosState createState() => _ListaEstabelecimentosState();
}

class _ListaEstabelecimentosState extends State<ListaEstabelecimentos> {
  List<String> filteredList = [];

  void onSearch(List<String> list) {
    setState(() {
      filteredList = list;
    });
  }

  final Stream<QuerySnapshot<Object?>> _favouriteBusinesses =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
          .getUserFavoritesSnapshot();

  final Stream<QuerySnapshot<Object?>> _allBusinesses =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "").getAllBusinesses();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 252, 247),
        body: StreamBuilder(
          stream: _allBusinesses,
          builder: (context, allBusinessesSnapshot) {
            if (!allBusinessesSnapshot.hasData) {
              return Center(
                child: const Text(
                  "A carregar os estabelecimentos...",
                ),
              );
            }

            return StreamBuilder(
              stream: _favouriteBusinesses,
              builder: (context, favoritesSnapshot) {
                if (favoritesSnapshot.data == null) {
                  return Center(
                    child: const Text(
                      "A carregar os favoritos...",
                    ),
                  );
                }

                return Center(
                  child: Column(
                    children: [
                      BusinessSearchBar(
                          botaoList: allBusinessesSnapshot.data!.docs,
                          onSearch: onSearch),
                      Expanded(
                        child: ListView(
                          children: allBusinessesSnapshot.data!.docs.map(
                            (botao) {
                              if (filteredList.isNotEmpty &&
                                  !filteredList.contains(botao.id)) {
                                return Container();
                              }

                              final Stream<String> businessImageStream =
                                  StorageService().getBusinessImage(
                                uid: botao.id,
                              );

                              return StreamBuilder(
                                  stream: businessImageStream,
                                  builder: (context, imageSnapshot) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Botao(
                                        businessUid: botao.id,
                                        image: imageSnapshot.data == null
                                            ? ""
                                            : imageSnapshot.data!,
                                        name: GetSnapshotData().getUserField(
                                          snapshotData: botao,
                                          fieldName: "business_name",
                                        ),
                                        type: GetSnapshotData().getUserField(
                                          snapshotData: botao,
                                          fieldName: "type",
                                        ),
                                        localization:
                                            GetSnapshotData().getUserField(
                                          snapshotData: botao,
                                          fieldName: "address",
                                        ),
                                        isFavorite:
                                            favoritesSnapshot.data!.docs.any(
                                          (element) =>
                                              element.get("business_uid") ==
                                              botao.id,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
