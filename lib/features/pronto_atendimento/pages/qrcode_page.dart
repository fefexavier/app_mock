import 'dart:convert';

import 'package:app_mock/core/colors';
import 'package:app_mock/core/repositories/local_storage.dart';
import 'package:app_mock/core/widgets/loading_screen.dart';
import 'package:app_mock/features/pronto_atendimento/controller/atendimento_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/services/app_enums.dart';

class QrcodePage extends StatefulWidget {
  final AtendimentoController controller;

  QrcodePage(this.controller, {Key? key}) : super(key: key);

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
   Map<String, dynamic> jsonMap = {};
  late String jsonData;
  final ILocalStorage storage = Modular.get();
  @override
  void initState() {
    super.initState();
    widget.controller.qrcode.idUsuario != '' ? 
    jsonMap = {
      "idusuario": widget.controller.qrcode.idUsuario,
      "idHospital": widget.controller.qrcode.hospital!.id,
      "idespecialidade":  widget.controller.qrcode.especialidade!.id, // Caso não haja um valor específico
      "idGuia":  widget.controller.qrcode.idGuia,
    } : null;
    jsonData = jsonEncode(jsonMap);
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ValueListenableBuilder(
            valueListenable: widget.controller.stateEnvioassinatura,
            builder: (context, state, child) {
              if (state == PaginateState.loading || state == PaginateState.infinityLoading) {
                return const Center(
                  child: LoadingScreen(),
                );
              } else if (state == PaginateState.error) {
                return Center(
                  child: Text(
                    'Erro ao solicitar qrcode, entre em contato com o plano de saúde.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state == PaginateState.start) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gere a Guia de Autorização do Plano e a assine',
                      style: TextStyle(color: lightColor.brandSecondary, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/logo2.png',
                      height: 200,
                    ),
                  ],
                );
              } else if (state == PaginateState.sucess) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Seu QR code com a guia de autorização liberada está pronto! Agora dirija-se ao hospital.",
                      style: TextStyle(color: lightColor.brandPrimary, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: QrImageView(
                        data: jsonData,
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink(); // Retorna vazio se o estado for inválido
            },
          ),
        ),
    );
   
  }
}
