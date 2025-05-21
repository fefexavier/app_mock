// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:app_mock/features/home/service/home_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/repositories/local_storage.dart';

class HomeController {
  final repository = Modular.get<HomeRepository>();

  // AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  Future<void> saveUser(BuildContext context) async {
      final ILocalStorage storage = Modular.get();
  }





  setUser() async{
   var usuario =  await repository.getUsuario();

   // storage.setUser(user);
  }


 
}
