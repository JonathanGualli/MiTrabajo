import 'package:flutter/material.dart';
import 'package:mi_trabajo/providers/global_variables_provider.dart';
import 'package:mi_trabajo/screens/activisys_screen.dart';
import 'package:mi_trabajo/screens/configuration_screen.dart';
import 'package:mi_trabajo/screens/home_screen.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:provider/provider.dart';

class BNavigation extends StatefulWidget {
  static const routeName = "/BNavigation";

  const BNavigation({super.key});

  @override
  State<BNavigation> createState() => _BNavigationState();
}

class _BNavigationState extends State<BNavigation> {
  late int index;

  List<Widget> pages = [
    const ActivitysScreen(),
    const HomeScreen(),
    const ConfigurationScreen()
  ];

  @override
  Widget build(BuildContext context) {
    index = Provider.of<GlobalVariables>(context).index;
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: navigationBar(),
    );
  }

  Widget navigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      unselectedItemColor: const Color(0xFFa19ba1),
      selectedItemColor: Colores.azul,
      currentIndex: index,
      onTap: (index) {
        setState(() {
          GlobalVariables.instance.index = index;
        });
      },
      //type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu_book_rounded,
            size: 35,
          ),
          label: "Actividades",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
            size: 35,
          ),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            size: 35,
          ),
          label: "Configuración",
        ),
      ],
    );
  }
}
