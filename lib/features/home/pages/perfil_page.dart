import 'package:app_mock/core/colors';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/repositories/local_storage.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final ILocalStorage storage = Modular.get();
String? userName;


  @override
  void initState() {
_loadUserName();
    super.initState();
  }

    Future<void> _loadUserName() async {
    final user = await storage.getUser();
    String? nome = user!.nome;
    setState(() {
      userName = nome ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: double.maxFinite,
          color: lightColor.brandPrimary,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              "Minha conta",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HeroIcon(
                  HeroIcons.user,
                  size: 60,
                  color: AppColor.getThemeColor(
                      darkColor.brandPrimary, lightColor.brandPrimary),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName?? "".toUpperCase(),
                    style:
                        TextStyle(color: lightColor.brandPrimary, fontSize: 18),
                  ),
                  Text(
                    "Informações da conta",
                    style: TextStyle(
                        color: lightColor.brandSecondary, fontSize: 14),
                  )
                ],
              ),
            ],
          ),
        ),


 _buildListItem(
            icon: Icons.person,
            text: "Alterar senha",
            onTap: () => Modular.to.pushNamed('alterar-senha'),
          ),
      
          _buildListItem(
            icon: Icons.lock,
            text: "Perguntas frequentes",
            onTap: () => Modular.to.pushNamed('perguntas'),
          ),
          _buildListItem(
            icon: Icons.payment,
            text: "Sobre",
            onTap: () => Modular.to.pushNamed('sobre'),
          ),
      
        
          _buildListItem(
            icon: Icons.logout,
            text: "Sair",
            onTap: () {
              // Exemplo de ação de logout
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Sair"),
                  content: Text("Tem certeza de que deseja sair?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Logica para logout
                        Navigator.pop(context);
                        Modular.to.pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      child: Text("Sair"),
                    ),
                  ],
                ),
              );
            },
          ),



      ],
    );
  }
}



 Widget _buildListItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: lightColor.brandPrimary),
        title: Text(text),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
