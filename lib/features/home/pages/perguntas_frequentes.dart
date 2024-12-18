import 'package:app_mock/core/colors';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:app_mock/core/widgets/text.dart'; // Se necessário, adicione os imports corretos
import '../../../core/repositories/local_storage.dart'; // Certifique-se de que o caminho está correto

class PerguntasFrequentesPage extends StatefulWidget {
  const PerguntasFrequentesPage({super.key});

  @override
  State<PerguntasFrequentesPage> createState() => _PerguntasFrequentesPageState();
}

class _PerguntasFrequentesPageState extends State<PerguntasFrequentesPage>
    with AutomaticKeepAliveClientMixin {
  final ILocalStorage storage = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Map<String, String>> faqData = [
    {
      'question': 'Como faço para criar uma conta?',
      'answer': 'Você pode criar uma conta clicando no botão "Cadastrar" na tela inicial e fornecendo seus dados pessoais.'
    },
    {
      'question': 'Como posso resetar minha senha?',
      'answer': 'Caso tenha esquecido sua senha, clique em "Esqueci minha senha" na tela de login e siga as instruções para recuperá-la.'
    },
    {
      'question': 'Quais hospitais estão disponíveis no app?',
      'answer': 'Atualmente, o aplicativo está integrado com vários hospitais. Você pode ver a lista completa de hospitais ao selecionar a especialidade médica desejada.'
    },
    {
      'question': 'Posso emitir a Guia de Autorização em qualquer hospital?',
      'answer': 'Sim, você pode emitir a Guia de Autorização para qualquer hospital cadastrado no sistema de planos de saúde que o aplicativo suporte.'
    },
    {
      'question': 'O que é o pré-check-in?',
      'answer': 'O pré-check-in permite que você faça o cadastro antecipado no hospital selecionado, gerando um QR Code para ser utilizado na entrada, eliminando a necessidade de filas.'
    },
  ];

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
                'Perguntas frequentes',
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
        body: ListView.builder(
          itemCount: faqData.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                faqData[index]['question']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(faqData[index]['answer']!),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
