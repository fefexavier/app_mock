import 'package:app_mock/core/colors';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/pronto_atendimento/controller/atendimento_controller.dart';
import 'package:app_mock/features/pronto_atendimento/pages/assinar_guia_page.dart';
import 'package:app_mock/features/pronto_atendimento/pages/gerar_guia_page.dart';
import 'package:app_mock/features/pronto_atendimento/pages/qrcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProntoAtendimentoFluxoPage extends StatefulWidget {
  const ProntoAtendimentoFluxoPage({Key? key}) : super(key: key);

  @override
  State<ProntoAtendimentoFluxoPage> createState() =>
      _ProntoAtendimentoFluxoPageState();
}

class _ProntoAtendimentoFluxoPageState extends State<ProntoAtendimentoFluxoPage>
    with SingleTickerProviderStateMixin {
    final AtendimentoController controller = Modular.get();

  @override
  void initState() {
    super.initState();

 
    controller.initTabController(this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          controller: controller.tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: const Color.fromARGB(255, 145, 173, 170),
          tabs: const [
            Tab(text: 'Gerar Guia'),
            Tab(text: 'Assinar Guia'),
            Tab(text: 'QR Code'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children:  [
          GerarGuiaPage(controller),
          AssinarGuiaPage(controller),
          QrcodePage(controller),
        ],
      ),
    );
  }
}
