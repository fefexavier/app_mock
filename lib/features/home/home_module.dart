import 'package:app_mock/features/home/pages/alterar_senha.dart';
import 'package:app_mock/features/home/pages/base_page.dart';
import 'package:app_mock/features/home/pages/perguntas_frequentes.dart';
import 'package:app_mock/features/home/pages/sobre.dart';
import 'package:app_mock/features/login/controller/login_controller.dart';
import 'package:app_mock/features/pronto_atendimento/pronto_atendimento_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i..add(LoginController.new);
  }

  @override
  void routes(RouteManager r) {
    r
      ..child(
        '/',
        child: (_) => BasePage(),
      )
      ..child('/sobre',child: (_) => SobrePage(),)
       ..child('/perguntas',child: (_) => PerguntasFrequentesPage(),)
              ..child('/alterar-senha',child: (_) => AlterarSEnhaPage(),)
      ..module('/pa', module: ProntoAtendimentoModule());
  }
}
