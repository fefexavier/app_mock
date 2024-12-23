import 'package:app_mock/core/services/http.dart';
import 'package:app_mock/features/home/home_module.dart';
import 'package:app_mock/features/login/controller/login_controller.dart';
import 'package:app_mock/features/login/login_service/login_service.dart';
import 'package:app_mock/features/login/pages/login_page.dart';
import 'package:app_mock/features/login/pages/primeiro_acesso_arquivo.dart';
import 'package:app_mock/features/login/pages/primeiro_acesso_page.dart';
import 'package:app_mock/features/login/pages/primeiro_acesso_senha.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/repositories/local_storage.dart';

class LoginModule extends Module {
  @override
  void binds(Injector i) {
    i
    ..addSingleton<ILocalStorage>(LocalStorage.new)
    ..add(LoginService.new)
    ..add(HttpClient.new)
    ..add(LoginController.new);

   
     }

  @override
  void routes(RouteManager r) {
    r
      ..child(
        '/primeiro-acesso',
        child: (_) => const PrimeiroAcessoPage(),
      )
      ..module('/base', module: HomeModule())
      ..child(
        '/primeiro-acesso-arquivo',
        child: (_) => const PrimeiroAcessoArquivoPage(),
      )
      ..child(
        '/primeiro-acesso-senha',
        child: (_) => const PrimeiroAcessoSenhaPage(),
      )
      ..child('/', child: (context) => LoginPage());
  }
}
