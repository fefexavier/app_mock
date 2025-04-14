import 'dart:convert';

import 'package:app_mock/core/colors';
import 'package:app_mock/core/repositories/local_storage.dart';
import 'package:app_mock/core/services/http.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class LoginService {
  LoginService(this.client);
  final HttpClient client;
  final ILocalStorage storage = Modular.get();
  Future<List<OperadoraPlanoSaude>> getPlanos() async {
    try {
      final url = Uri.https('fila-app-two.vercel.app', '/operadoras');
      final res = await client.get(url);

      if (res.statusCode != 200) {
        throw Exception('Erro na requisição: ${res.statusCode}');
      }

      try {
        // Decodifica o corpo da resposta
        // Obtém a lista de operadoras
        final List<dynamic> operadorasList = json.decode(res.body);

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

  Future<void> cadastrarUsuario(BuildContext context ) async {
    try {
      // Recupera o usuário
      final usuario = await storage.getUser();

      // Caso não exista um usuário retornado
      if (usuario == null) {
        throw Exception('Usuário não encontrado');
      }

      // Monta a URL

      // Cria uma requisição MultipartRequest para enviar form-data

      final url = Uri.https('fila-app-two.vercel.app', '/login/new');

      final request = http.MultipartRequest('POST', url);

      // Adiciona os campos ao form-data
      request.fields['cpf'] = usuario.cpf ?? '';
      request.fields['nome'] = usuario.nome ?? '';
      request.fields['endereco'] = (usuario.endereco ?? '').substring(0,50); // TODO: Validar como tratar esse dado
      request.fields['cep'] = usuario.cep ?? '';
      request.fields['numeroEndereco'] = usuario.numeroEndereco ?? '';
      request.fields['complementoEndereco'] = usuario.complementoEndereco ?? '';
      request.fields['comprovanteResidencia'] = usuario.comprovanteResidencia ?? '';
      request.fields['telefone'] = usuario.telefone ?? '';
      request.fields['email'] = usuario.email ?? '';
      request.fields['operadoraId'] = usuario.operadoraId ?? '';
      request.fields['numeroCarteira'] = usuario.numeroCarteira ?? '';
      request.fields['imagemPerfil'] = usuario.imagemPerfil ?? '';
      request.fields['documentoAssinado'] = usuario.documentoAssinado ?? '';
      request.fields['dataNascimento'] = usuario.dataNascimento ?? '';
      request.fields['senha'] = usuario.senha ?? 'teste';

      // Faz o POST convertendo o body para JSON
      final res = await request.send();

      // Verifica se ocorreu algum erro
      if (res.statusCode != 201) {
     ScaffoldMessenger.of(context).showSnackBar(
              const   SnackBar(
                  content: Text('Houve um erro ao cadastrar usuário, entre em contato com o Plano'),
                  duration: Duration(seconds: 3),
               backgroundColor: Colors.red,
                ),
              );
        final resBody = await res.stream.bytesToString();
        throw Exception('Erro ao cadastrar usuário: $resBody');
      }

     ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('Usuário cadastrado com sucesso!'),
               backgroundColor: lightColor.brandPrimary,
                ),
              );
      Modular.to.pushNamed('/');
    } catch (e, stacktrace) {
      print('Error: $e\nStack: $stacktrace');
    }
  }

  Future<void> logarUsuario(BuildContext context, String cpf, String pass ) async {
    try {

      // Monta a URL
      final url = Uri.https('fila-app-two.vercel.app', '/login');

      // Monta o body em formato de Map
      final bodyMap = {
        'cpf': cpf ,
        'password': pass
      };

      // Faz o POST convertendo o body para JSON
      final res = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );

      // Verifica se ocorreu algum erro
      if (res.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const   SnackBar(
            content: Text('Credenciais Incorretas'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception('Erro ao realizar login: ${res.body}');
      }

      final body = utf8.decode(res.bodyBytes);
      final Map<String, dynamic> decodedBody = json.decode(body);

      if (!decodedBody.containsKey('token') ) {
        throw Exception('Estrutura da resposta inválida');
      }

      final String tokenDecode = (decodedBody['token'] as String);

      await storage.setToken(tokenDecode);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Autenticacao realizada com sucesso!'),
          backgroundColor: lightColor.brandPrimary,
        ),
      );
      Modular.to.pushNamed('base');
    } catch (e, stacktrace) {
      print('Error: $e\nStack: $stacktrace');
    }
  }


}
