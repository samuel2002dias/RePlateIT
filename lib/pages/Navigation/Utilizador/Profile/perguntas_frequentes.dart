import 'package:flutter/material.dart';

class PerguntasFrequentes extends StatelessWidget {
  const PerguntasFrequentes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 252, 247),
        title: const Text("Ajuda"),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ListView(
            children: const [
              Text(
                "Perguntas Frequentes",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Nunito',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  tilePadding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  title: Text('Como posso reservar comida?'),
                  collapsedBackgroundColor: Color.fromARGB(233, 144, 238, 96),
                  backgroundColor: Color.fromARGB(233, 194, 231, 176),
                  children: <Widget>[
                    Text(
                      'Et culpa id eu aliqua deserunt minim cupidatat in proident. Culpa do incididunt mollit aliquip tempor qui eiusmod duis qui reprehenderit nulla incididunt. Pariatur est et esse non in nisi est id.',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  tilePadding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  title: Text(
                      'Como os restaurantes irão saber que fui eu que fiz a reserva?'),
                  collapsedBackgroundColor: Color.fromARGB(255, 144, 238, 96),
                  backgroundColor: Color.fromARGB(255, 194, 231, 176),
                  children: <Widget>[
                    Text(
                        'Aliqua proident id voluptate proident duis laborum. Qui velit anim enim exercitation ut in velit do Lorem amet aute. Non enim ex duis sunt tempor in tempor fugiat magna nostrud commodo aliqua voluptate cupidatat. Sunt nulla anim non magna nostrud adipisicing voluptate ex laborum. Nostrud cillum cupidatat proident consequat non eiusmod commodo id. Est veniam ullamco velit ex elit laborum minim consequat proident adipisicing commodo.')
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: ExpansionTile(
                  childrenPadding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  tilePadding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  title: Text(
                      'Com que frequência posso usar os serviços FoodForward?'),
                  collapsedBackgroundColor: Color.fromARGB(255, 144, 238, 96),
                  backgroundColor: Color.fromARGB(255, 194, 231, 176),
                  children: <Widget>[
                    Text(
                        'Culpa nisi cillum irure est magna tempor officia exercitation et sit labore quis do. Ut velit aliqua irure aliquip incididunt esse reprehenderit labore excepteur exercitation adipisicing et id. Et id adipisicing anim nulla sit culpa fugiat adipisicing nisi nostrud.')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
