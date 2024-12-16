import 'dart:convert';
import 'dart:developer';

import 'package:app_mock/core/services/app_enums.dart';
import 'package:app_mock/features/pronto_atendimento/model/especialidade_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/hospital_model.dart';
import 'package:app_mock/features/pronto_atendimento/service/pronto_atendimento_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AtendimentoController {
  final repository = Modular.get<AtendimentoRepository>();

  // Estados para diferentes operações
  ValueNotifier<PaginateState> stateHospital = ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateOperadoras = ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateEspecialidades = ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateUsuario = ValueNotifier(PaginateState.start);
  ValueNotifier<PaginateState> stateAutorizacao = ValueNotifier(PaginateState.start);

  // Dados armazenados localmente
  List<Hospital> hospitais = [];
  List<Map<String, dynamic>> operadoras = [];
  List<Especialidade> especialidades = [];
  Map<String, dynamic> usuario = {};

  // Métodos para consumir os endpoints

  // Obter Hospitais
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

  // Realizar Autorização Guia
  Future<bool> realizarAutorizacaoGuia(Map<String, dynamic> guiaData) async {
    stateAutorizacao.value = PaginateState.loading;

    try {
      final sucesso = await repository.realizarAutorizacaoGuia(guiaData);
      if (sucesso) {
        stateAutorizacao.value = PaginateState.sucess;
        log('Autorização realizada com sucesso');
      } else {
        stateAutorizacao.value = PaginateState.error;
        log('Falha ao realizar autorização');
      }
      return sucesso;
    } catch (e) {
      stateAutorizacao.value = PaginateState.error;
      log('Erro ao realizar autorização: $e');
      return false;
    }
  }
}
