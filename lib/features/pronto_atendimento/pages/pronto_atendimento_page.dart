import 'package:app_mock/core/colors';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/pronto_atendimento/pages/assinar_guia_page.dart';
import 'package:app_mock/features/pronto_atendimento/pages/gerar_guia_page.dart';
import 'package:app_mock/features/pronto_atendimento/pages/qrcode_page.dart';
import 'package:flutter/material.dart';

class ProntoAtendimentoFluxoPage extends StatefulWidget {
  const ProntoAtendimentoFluxoPage({super.key});

  @override
  State<ProntoAtendimentoFluxoPage> createState() => _ProntoAtendimentoFluxoPageState();
}

class _ProntoAtendimentoFluxoPageState extends State<ProntoAtendimentoFluxoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Número de abas
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: lightColor.brandPrimary,
          title: GradientText(
            'Pronto Atendimento',
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(250, 251, 251, 1),
              Color.fromRGBO(131, 197, 190, 1),
            ]),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
labelColor: Colors.white,    
unselectedLabelColor: Color.fromARGB(255, 145, 173, 170),
        tabs: [
              Tab(text: 'Gerar Guia', ),
              Tab(text: 'Assinar Guia'),
              Tab(text: 'QR Code'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GerarGuiaPage(),
            AssinarGuiaPage(),
          QrcodePage(),
          ],
        ),
      ),
    );
  }
}