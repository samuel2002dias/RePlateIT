// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:main/pages/Navigation/Utilizador/Chat/chat.dart';
import 'package:main/pages/Navigation/Utilizador/Favorites/favourites.dart';
import 'package:main/pages/Navigation/Utilizador/Main/lista_estabelecimentos.dart';
import 'package:main/pages/Navigation/Utilizador/Profile/perfil.dart';
import 'package:main/pages/Navigation/Utilizador/Reservations/reservas.dart';

/* Em caso de quererem testar o código sem ter que passar pela parte de login, 
  descomentem o main. Caso haja algum erro comentem o NavegacaoClean */
// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Navegacao(),
//     );
//   }
// }

class Navegacao extends StatefulWidget {
  const Navegacao({super.key});

  @override
  State<Navegacao> createState() => _NavegacaoState();
}

class _NavegacaoState extends State<Navegacao> {
  int _selectedIndex = 0;

  // Associar cada índice a uma parte do programa
  final List<Widget> _widgetOptions = <Widget>[
    const ListaEstabelecimentos(),
    const Reservas(),
    const Favourites(),
    const ChatPage(),
    const Perfil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 5,
        backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      ),
      backgroundColor: const Color.fromARGB(255, 254, 252, 247),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: ConvexAppBar(
          backgroundColor: const Color(0xFF90EE60),
          activeColor: const Color(0xFF90EE60),
          style: TabStyle.custom,
          curveSize: 100,
          items: const [
            TabItem(
              icon: ImageIcon(
                AssetImage("images/icons/HomeTransparente.png"),
                color: Colors.white,
              ),
            ),
            TabItem(
              icon: ImageIcon(
                AssetImage("images/icons/ReservasTransparente.png"),
                color: Colors.white,
              ),
            ),
            TabItem(
              icon: ImageIcon(
                AssetImage("images/icons/FavoritosTransparente.png"),
                color: Colors.white,
              ),
            ),
            TabItem(
              icon: ImageIcon(
                AssetImage("images/icons/MSGTransparente.png"),
                color: Colors.white,
              ),
            ),
            TabItem(
              icon: ImageIcon(
                AssetImage("images/icons/PerfilTransparente.png"),
                color: Colors.white,
              ),
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
