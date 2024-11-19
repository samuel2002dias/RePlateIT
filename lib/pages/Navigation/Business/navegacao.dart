import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:main/pages/Navigation/Business/Chat/chat.dart';
import 'package:main/pages/Navigation/Business/Profile/perfil.dart';

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

class NavegacaoBusiness extends StatefulWidget {
  const NavegacaoBusiness({super.key});

  @override
  State<NavegacaoBusiness> createState() => _NavegacaoBusinessState();
}

class _NavegacaoBusinessState extends State<NavegacaoBusiness> {
  int _selectedIndex = 0;

  // Associar cada índice a uma parte do programa
  final List<Widget> _widgetOptions = <Widget>[
    const Text('Definições'),
    const Text('Publicações'),
    const BusinessChatPage(),
    const BusinessProfile(),
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
        toolbarHeight: 4,
        backgroundColor: const Color.fromARGB(
          255,
          53,
          51,
          47,
        ),
      ),
      backgroundColor: const Color.fromARGB(
        255,
        53,
        51,
        47,
      ),
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
                AssetImage("images/icons/PainelControlo.png"),
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
