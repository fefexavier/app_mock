import 'package:app_mock/core/colors';
import '../../../core/repositories/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:heroicons/heroicons.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChanged;

  const HomeScreen({super.key, required this.onTabChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ILocalStorage storage = Modular.get();
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Olá, ${userName.toUpperCase()}",
                    style:
                        TextStyle(color: lightColor.brandPrimary, fontSize: 18),
                  ),
                  Text(
                    "Em que podemos te ajudar?",
                    style: TextStyle(
                        color: lightColor.brandSecondary, fontSize: 14),
                  )
                ],
              ),
              HeroIcon(
                HeroIcons.user,
                size: 60,
                color: AppColor.getThemeColor(
                    darkColor.brandPrimary, lightColor.brandPrimary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  widget.onTabChanged(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightColor.brandPrimary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Pronto Atendimento',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Modular.to.pushNamed('rede-credenciada');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightColor.brandPrimary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Rede credenciada',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightColor.brandPrimary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Carteirinha',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
