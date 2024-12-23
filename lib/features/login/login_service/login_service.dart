import 'dart:convert';

import 'package:app_mock/core/colors';
import 'package:app_mock/core/repositories/local_storage.dart';
import 'package:app_mock/core/services/http.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginService {
  LoginService(this.client);
  final HttpClient client;
  final ILocalStorage storage = Modular.get();
  Future<List<OperadoraPlanoSaude>> getPlanos() async {
    try {
      final url = Uri.https('fila.wiremockapi.cloud', '/operadoras');
      final res = await client.get(url);

      if (res.statusCode != 200) {
        throw Exception('Erro na requisição: ${res.statusCode}');
      }

      try {
        // Decodifica o corpo da resposta
        //final body = utf8.decode(res.bodyBytes);
        final Map<String, dynamic> mapResponse = json.decode(res.body);

        // Obtém a lista de operadoras
        final List<dynamic> operadorasList =
            mapResponse['operadorasPlanoSaude'];

        if (operadorasList.any((item) => item is! Map<String, dynamic>)) {
          throw Exception(
              'A lista de operadoras contém itens de tipo inválido');
        }

        // Converte a lista de mapas para uma lista de objetos OperadoraPlanoSaude
        return operadorasList.map((operadoraMap) {
          return OperadoraPlanoSaude.fromJson(operadoraMap);
        }).toList();
      } catch (e) {
        print('Erro ao decodificar o JSON: $e');
        throw Exception('Erro ao decodificar o JSON da resposta');
      }
    } catch (e, stackTrace) {
      print('Erro em getPlanos: $e');
      print(stackTrace);
      throw Exception('Erro ao buscar operadoras');
    }
  }

  Future<void> cadastrarUsuario() async {
    try {
      // Recupera o usuário
      final usuario = await storage.getUser();

      // Caso não exista um usuário retornado
      if (usuario == null) {
        throw Exception('Usuário não encontrado');
      }

      // Monta a URL
      final url = Uri.https('fila.wiremockapi.cloud', '/usuario');

      // Monta o body em formato de Map
      final bodyMap = {
        'cpf': usuario.cpf ?? '',
        'nome': usuario.nome ?? '',
        'endereco': usuario.endereco ?? '',
        'cep': usuario.cep ?? '',
        'numero': usuario.numeroEndereco ?? '',
        'complemento': usuario.complementoEndereco ?? '',
        'comprovanteResidencia': usuario.comprovanteResidencia ?? '',
        'telefone': usuario.telefone ?? '',
        'email': usuario.email ?? '',
        'planoDeSaudeId': usuario.planoSaude ?? '',
        'numeroCarteira': usuario.numeroCarteira ?? '',
        'imagemPerfil': usuario.imagemPerfil ?? '',
      };

      // Faz o POST convertendo o body para JSON
      final res = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );

      // Verifica se ocorreu algum erro
      if (res.statusCode != 200) {
        Asuka.showSnackBar(SnackBar(
          content: Text('Erro ao cadastrar usuário, contate o plano de saúde'),
          backgroundColor: Colors.red,
        ));
        throw Exception('Erro ao cadastrar usuário: ${res.body}');
      }

      Asuka.showSnackBar(SnackBar(
          content: Text('Usuário cadastrado com sucesso!'),
          backgroundColor: lightColor.brandPrimary));
    } catch (e, stacktrace) {
      print('Error: $e\nStack: $stacktrace');
    }
  }
}
