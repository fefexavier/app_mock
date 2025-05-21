import 'package:app_mock/core/colors';
import 'package:app_mock/features/home/controller/home_controller.dart';
import 'package:app_mock/features/home/pages/home_page.dart';
import 'package:app_mock/features/home/pages/perfil_page.dart';
import 'package:app_mock/features/home/pages/pronto_atendimento_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;
final HomeController controller = Modular.get();
  // Ajuste aqui para passar a função de mudança de aba
  static List<Widget> _screens(BuildContext context, Function(int) onTabChanged) {
    return <Widget>[
      HomeScreen(onTabChanged: onTabChanged),
      ProntoAtendimentoPage(),
      PerfilPage(),
    ];
  }

  @override
  void initState() {
controller.setUser();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens(context, _onItemTapped).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: lightColor.brandPrimary,
        unselectedItemColor: lightColor.brandTertiary, // Cor dos itens não selecionados
        selectedItemColor: Colors.white, // Cor da letra do item selecionado
        selectedIconTheme: IconThemeData(color: Colors.white),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Pronto-atendimento',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

