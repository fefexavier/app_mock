import 'package:app_mock/core/colors';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChanged; 


  HomeScreen({required this.onTabChanged});

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
                    "Olá, Fulano ".toUpperCase(),
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
            SizedBox(height:  MediaQuery.of(context).size.height * 0.1,),
            SizedBox(
              
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  onTabChanged(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      lightColor.brandPrimary, // Cor do texto (branco)
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordas arredondadas
                  ),
                  // Padding
                ),
                child: Text(
                  'Pronto Atendimento',
                  style: TextStyle(
                      fontSize: 19, color: Colors.white), // Tamanho do texto
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      lightColor.brandPrimary, // Cor do texto (branco)
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordas arredondadas
                  ),
                  // Padding
                ),
                child: Text(
                  'Rede credenciada',
                  style: TextStyle(
                      fontSize: 19, color: Colors.white), // Tamanho do texto
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      lightColor.brandPrimary, // Cor do texto (branco)
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordas arredondadas
                  ),
                  // Padding
                ),
                child: Text(
                  'Carteirinha',
                  style: TextStyle(
                      fontSize: 19, color: Colors.white), // Tamanho do texto
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
