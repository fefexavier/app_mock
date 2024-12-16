import 'package:app_mock/core/colors';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:heroicons/heroicons.dart';

class ProntoAtendimentoPage extends StatefulWidget {
  const ProntoAtendimentoPage({super.key});

  @override
  State<ProntoAtendimentoPage> createState() => _ProntoAtendimentoPageState();
}

class _ProntoAtendimentoPageState extends State<ProntoAtendimentoPage> {
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
        
          
          children: [
            SizedBox(height: MediaQuery.of(context).size.height *0.25,),
           SizedBox(
                  
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 80,
                  child: ElevatedButton(
                    onPressed: () {
                   //  Modular.to.popAndPushNamed("pa");
                      //  Modular.to.pushNamed('/pa');
                          Modular.to.pushNamed('pa');
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
                      'Iniciar atendimento',
                      style: TextStyle(
                          fontSize: 19, color: Colors.white), // Tamanho do texto
                    ),
                  ),
                ),
        ],),
      ],
    );

  }
}