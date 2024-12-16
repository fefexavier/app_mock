import 'package:app_mock/core/services/http.dart';
import 'package:app_mock/features/login/controller/login_controller.dart';
import 'package:app_mock/features/pronto_atendimento/controller/atendimento_controller.dart';
import 'package:app_mock/features/pronto_atendimento/pages/pronto_atendimento_page.dart';
import 'package:app_mock/features/pronto_atendimento/service/pronto_atendimento_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProntoAtendimentoModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..add(AtendimentoRepository.new)
        ..add(HttpClient.new)
        ..add(AtendimentoController.new)
    ..add(LoginController.new);
  }

  @override
  void routes(RouteManager r) {
    r
   
  
      ..child('/', child: (context) => ProntoAtendimentoFluxoPage());
  }
}
