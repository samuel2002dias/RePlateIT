import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/pages/Navigation/Utilizador/Main/detail_page.dart';
import 'package:main/services/auth.dart';
import 'package:main/services/firestore.dart';

class Botao extends StatefulWidget {
  final String businessUid;
  final String image;
  final String name;
  final String type;
  final String localization;
  final bool isFavorite;

  const Botao({
    super.key,
    required this.businessUid,
    required this.image,
    required this.name,
    required this.type,
    required this.localization,
    this.isFavorite = false,
  });

  @override
  _BotaoState createState() => _BotaoState();
}

class _BotaoState extends State<Botao> {
  bool _isFavourite = false;

  void addToFavorites() async {
    FirestoreService firestoreInstance =
        FirestoreService(uid: Auth().currentUser()?.uid ?? "");

    try {
      if (_isFavourite == true) {
        await firestoreInstance.removeFavourite(
            businessUid: widget.businessUid);
      } else {
        await firestoreInstance.addFavorite(businessUid: widget.businessUid);
      }
    } on FirebaseException catch (e) {
      SnackBar(
        content: Text(e.message ?? "Erro ao atualizar favorito"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      );
    }

    setState(() {
      _isFavourite = !_isFavourite;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _isFavourite = widget.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: double.infinity,
        height: 170.0,
        child: Stack(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Detail(botao: widget),
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFFFFFFF)),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
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
                            image: widget.image.isEmpty
                                ? Image.asset("images/background.jpg").image
                                : Image.network(widget.image).image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 7,
                        bottom: 4,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Nunito',
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 5), // Espaçamento
                          Text(
                            widget.type,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Nunito',
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            widget.localization,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Nunito',
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: ImageIcon(
                  AssetImage(
                    _isFavourite
                        ? "images/icons/FavoritosTransparente.png"
                        : "images/icons/FavoritosCheckTrnasparente.png",
                  ),
                  color: Colors.white,
                ),
                onPressed: addToFavorites,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
