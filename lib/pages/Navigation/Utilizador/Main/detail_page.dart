// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/helpers/getSnapshopData.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';
import 'package:main/services/storage.dart';
import 'package:main/widgets/FormPratos.dart';
import 'package:main/pages/Navigation/Utilizador/Reservations/realizar_reservas.dart';
import 'package:main/pages/Navigation/Utilizador/Chat/chat.dart';
import 'package:main/pages/Navigation/Utilizador/Main/publicacoes.dart';
import 'package:main/widgets/estabelecimentos_botao.dart';

/*Reminder: Alterar o texto de doses disponiveis para acompanhar o numero de doses disponiveis do artigo que aparece na detail page no estabelecimento*/
class Detail extends StatefulWidget {
  final Botao botao;

  const Detail({Key? key, required this.botao}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return DetailPage(botao: widget.botao);
  }
}

class DetailPage extends StatelessWidget {
  final Botao botao;

  DetailPage({required this.botao});

  late final Stream<QuerySnapshot<Object?>> _allBusinessDishes =
      FirestoreService(uid: Auth().currentUser()?.uid ?? "")
          .getBusinessDishes(businessUid: botao.businessUid);

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
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: SizedBox(
              width: 300.0,
              height: 170.0,
              child: Stack(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFFFFFFF),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                          ),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(botao.image),
                                  fit: BoxFit.cover,
                                ),
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
          ),
          // Additional content for the DetailPage
          Padding(
            padding: EdgeInsets.only(left: 30.0, top: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                botao.type,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                botao.localization,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Divider(color: Colors.transparent, thickness: 3.0),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 30.0, bottom: 20.0),
            child: Text("Doses Disponiveis",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Container(
            width: 150, // 2 * radius
            height: 150, // 2 * radius
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(148, 248, 102, 1),
                width: 3.0,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "12/12",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Divider(color: Colors.transparent, thickness: 3.0),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Publicações",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 120.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Publicacoes(
                            botao: botao,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Ver Mais",
                      style: TextStyle(
                        color: Color(0x72727272),
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: _allBusinessDishes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("A carregar o prato..."),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("Não existem pratos..."),
                );
              }

              Stream<String> getDishImage =
                  StorageService().getDishImage(uid: snapshot.data!.docs[0].id);

              return StreamBuilder(
                stream: getDishImage,
                builder: (context, imageSnapshot) {
                  if (!imageSnapshot.hasData) {
                    return Center(
                      child: Text("A carregar imagem do prato..."),
                    );
                  }

                  return Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 15.0, bottom: 10.0),
                    child: Pratos(
                      image: imageSnapshot.data ?? "",
                      nome_prato: GetSnapshotData().getUserField(
                          snapshotData: snapshot.data!.docs[0],
                          fieldName: "name"),
                      nr_doses: int.parse(GetSnapshotData().getUserField(
                          snapshotData: snapshot.data!.docs[0],
                          fieldName: "num_of_portion")),
                      index: snapshot.data!.docs[0].id,
                    ),
                  );
                },
              );
            },
          ),

          Padding(
            padding: EdgeInsets.only(
                top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatPage()), // Ensure you have a Chat class defined in Chat.dart
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
                    'Mensagem',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
