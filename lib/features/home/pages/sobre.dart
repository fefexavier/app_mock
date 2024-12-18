import 'dart:convert';
import 'dart:io';

import 'package:app_mock/core/colors';
import 'package:app_mock/core/widgets/outline_buttom.dart';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/repositories/local_storage.dart';


class SobrePage extends StatefulWidget {
  const SobrePage({
    super.key,
  });
  @override
  State<SobrePage> createState() =>
      _SobrePageState();
}

class _SobrePageState extends State<SobrePage>
    with AutomaticKeepAliveClientMixin {
  final _formKeyacesso = GlobalKey<FormState>();

     final ILocalStorage storage = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: lightColor.brandPrimary,
              elevation: currentTheme.getIsDarkTheme() ? 0 : 2,
              shadowColor: Colors.grey[50],
              title: GradientText(
                'Sobre',
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(250, 251, 251, 1),
                  Color.fromRGBO(131, 197, 190, 1),
                ]),
              ),
              centerTitle: true,
              snap: true,
              floating: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: lightColor.brandPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: lightColor.grayBackground.withOpacity(0.3),
                        spreadRadius: 1.2,
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              surfaceTintColor:
                  AppColor.getThemeColor(darkColor.background, Colors.white),
              foregroundColor: currentTheme.getIsDarkTheme()
                  ? darkColor.background
                  : Colors.white,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Sobre o Aplicativo',
                
                  style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: lightColor.brandPrimary,
                      ),
                ),
                const SizedBox(height: 16),
                
                // Descrição do aplicativo
                Text(
                  'Este aplicativo foi desenvolvido para agilizar o atendimento emergencial nos hospitais, oferecendo uma maneira rápida e eficiente de realizar o pré-check-in e emitir a Guia de Autorização do Plano de Saúde de forma antecipada. Nosso objetivo é reduzir as filas e otimizar o tempo de espera, proporcionando uma experiência mais tranquila para os pacientes.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                
                // Missão do projeto
                Text(
                  'Missão',
               style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: lightColor.brandPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nossa missão é melhorar a experiência do paciente ao eliminar burocracias, oferecendo um atendimento mais rápido e eficiente em situações de emergência.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                
                // Visão do projeto
                Text(
                  'Visão',
                  style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: lightColor.brandPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Queremos ser a solução líder em agilização de processos hospitalares através da tecnologia, impactando positivamente a experiência dos pacientes e a eficiência dos hospitais.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                
                // Informações de contato (exemplo)
                Text(
                  'Contato',
                style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: lightColor.brandPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Se você tiver dúvidas ou sugestões, entre em contato conosco pelo e-mail: contato@appmock.com',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
