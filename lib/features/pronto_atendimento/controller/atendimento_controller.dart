import 'dart:convert';
import 'dart:developer';

import 'package:app_mock/core/services/app_enums.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/especialidade_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/hospital_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/qrcode_model.dart';
import 'package:app_mock/features/pronto_atendimento/service/pronto_atendimento_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AtendimentoController {
  final repository = Modular.get<AtendimentoRepository>();

  // Estados para diferentes operações
  ValueNotifier<PaginateState> stateHospital =
      ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateOperadoras =
      ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateEspecialidades =
      ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateUsuario =
      ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateAutorizacao =
      ValueNotifier(PaginateState.start);

        ValueNotifier<PaginateState> stateEnvioassinatura=
      ValueNotifier(PaginateState.start);

  ValueNotifier<PaginateState> assinarGuiaState =
      ValueNotifier(PaginateState.start);
  // Dados armazenados localmente
  List<Hospital> hospitais = [];
  List<Map<String, dynamic>> operadoras = [];
  List<Especialidade> especialidades = [];
  Map<String, dynamic> usuario = {};

  RetornoGuiaModel guia = RetornoGuiaModel();
TabController? tabController;

QrCodeModel qrcode = QrCodeModel(hospital: null , especialidade: null, idUsuario: '', idGuia: 0, imageGuia: '', selfieGuia: '', assinaturaGuia: '');


void initTabController(TickerProvider tickerProvider) {
  tabController = TabController(length: 3, vsync: tickerProvider);
}




  Future<void> getHospitais() async {
    stateHospital.value = PaginateState.loading;

    try {
      hospitais = await repository.getHospitais();
      stateHospital.value = PaginateState.sucess;
    } catch (e) {
      stateHospital.value = PaginateState.error;
      log('Erro ao buscar hospitais: $e');
    }
  }

  // Obter Operadoras
  Future<List<Map<String, dynamic>>> getOperadoras() async {
    stateOperadoras.value = PaginateState.loading;

    try {
      operadoras = await repository.getOperadoras();
      stateOperadoras.value = PaginateState.sucess;
    } catch (e) {
      stateOperadoras.value = PaginateState.error;
      log('Erro ao buscar operadoras: $e');
    }

    return operadoras;
  }

  // Obter Especialidades
  Future<void> getEspecialidades() async {
    stateEspecialidades.value = PaginateState.loading;

    try {
      especialidades = await repository.getEspecialidades();
      stateEspecialidades.value = PaginateState.sucess;
    } catch (e) {
      stateEspecialidades.value = PaginateState.error;
      log('Erro ao buscar especialidades: $e');
    }
  }

  // Obter Informações do Usuário
  Future<Map<String, dynamic>> getUsuario() async {
    stateUsuario.value = PaginateState.loading;

    try {
      usuario = await repository.getUsuario();
      stateUsuario.value = PaginateState.sucess;
    } catch (e) {
      stateUsuario.value = PaginateState.error;
      log('Erro ao buscar informações do usuário: $e');
    }

    return usuario;
  }

  // Cadastrar Usuário
  Future<bool> cadastrarUsuario(Map<String, dynamic> usuarioData) async {
    try {
      final sucesso = await repository.cadastrarUsuario(usuarioData);
      if (sucesso) {
        log('Usuário cadastrado com sucesso');
      } else {
        log('Falha ao cadastrar usuário');
      }
      return sucesso;
    } catch (e) {
      log('Erro ao cadastrar usuário: $e');
      return false;
    }
  }


    Future<bool> enviaGuiaAssinada(int idGuia, String image) async {
        stateEnvioassinatura.value = PaginateState.loading;
    try {
      final sucesso = await repository.enviaGuiaAssinada(idGuia, image);
      if (sucesso) {
               stateEnvioassinatura.value = PaginateState.loading;
        log('guia enviada com sucesso');
          stateEnvioassinatura.value = PaginateState.sucess;
      } else {
           stateEnvioassinatura.value = PaginateState.error;
        log('Falha aoenviar guia');
      }
      return sucesso;
    } catch (e) {
      log('Erro aoenviar guia: $e');
      return false;
    }
  }

  

  Future<void> solicitarGuiaAtendimento(int hospital, int especialidade) async {
    stateAutorizacao.value = PaginateState.loading;

    try {
      guia = await repository.solicitarGuiaAtendimento(
          hospitalId: hospital, especialidadeId: especialidade);
      if (guia.status == "Pendente Assinatura") {
        stateAutorizacao.value = PaginateState.sucess;
//tabController?.animateTo(1);


        log('Autorização realizada com sucesso');
      } else {
        stateAutorizacao.value = PaginateState.error;
        log('Falha ao realizar autorização');
      }
    } catch (e) {
      stateAutorizacao.value = PaginateState.error;
      log('Erro ao realizar autorização: $e');
    }
  }
}
