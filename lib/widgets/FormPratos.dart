// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

/* Reminder: 
A quantidade de artigos têm de estar associado a cada estabelecimento existente na base de dados, então como posso associar isto?
Isto é: 
 - O estabelecimento "Name 1" tem 10 artigos, mas tem 2 doses do artigo 1,3,5,7,9 e 10 doses do artigo 2,4,6,8 */

// List<Pratos> pratosList = List.generate(
//   10,
//   (index) {
//     return Pratos(
//       image: "images/background.jpg",
//       nome_prato: 'Prato $index',
//       nr_doses: 11,
//       index: index,
//     );
//   },
// );

// // mixin nr_doses {}

// ListPratos() {
//   return ListView.builder(
//     physics: NeverScrollableScrollPhysics(),
//     shrinkWrap: true,
//     itemCount: pratosList.length,
//     itemBuilder: (context, index) {
//       return pratosList[index];
//     },
//   );
// }

class Pratos extends StatefulWidget {
  final String image;
  final String nome_prato;
  final int nr_doses;
  final String index;
  final bool showPortions;

  Pratos({
    required this.image,
    required this.nome_prato,
    required this.index,
    required this.nr_doses,
    this.showPortions = true,
  });

  @override
  _PratosState createState() => _PratosState();
}

class _PratosState extends State<Pratos> {
  Widget change() {
    return Text(
      "${widget.nr_doses} ${widget.nr_doses == 1 ? "Dose" : "Doses"} ",
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'Nunito',
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: 200.0,
        height: 80.0,
        child: Stack(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFFFFFFFF)),
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
              child: Row(
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
                            image: NetworkImage(widget.image),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
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
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 10),
                            child: Text(
                              widget.nome_prato,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Nunito',
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0, top: 0),
                            child: widget.showPortions
                                ? change()
                                : Text(
                                    "1 dose",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
