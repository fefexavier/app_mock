import 'dart:async';
import 'dart:convert';

import 'package:app_mock/core/repositories/local_storage.dart';
import 'package:app_mock/core/services/http.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/especialidade_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/hospital_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AtendimentoRepository {
  AtendimentoRepository(this.client);
  final HttpClient client;
    final ILocalStorage storage = Modular.get();

  // Obter Hospitais
  Future<List<Hospital>> getHospitais() async {
    try {
      final url = Uri.https('fila.wiremockapi.cloud', '/hospitais');
      final res = await client.get(url);

      if (res.statusCode != 200) {
        throw Exception('Erro na requisição: ${res.statusCode}');
      }

      final body = utf8.decode(res.bodyBytes);
      final Map<String, dynamic> decodedBody = json.decode(body);

      if (!decodedBody.containsKey('hospitais') ||
          decodedBody['hospitais'] is! List) {
        throw Exception('Estrutura da resposta inválida');
      }

      return (decodedBody['hospitais'] as List)
          .map((e) => Hospital.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('Erro em getHospitais: $e');
      print(stackTrace);
      throw Exception('Erro ao buscar hospitais');
    }
  }



Future<RetornoGuiaModel> solicitarGuiaAtendimento({
  required int especialidadeId,
  required int hospitalId,
}) async {
  try {
    // Obtendo o usuário do armazenamento
    final usuario = await storage.getUser();
    
    // Verificando se o usuário foi encontrado
    if (usuario == null) {
      throw Exception('Usuário não encontrado');
    }

    final url = Uri.https('fila.wiremockapi.cloud', '/autorizacao');
    
    // Enviando a requisição POST
    final res = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'idUsuario': usuario.cpf,
        'especialidadeId': especialidadeId,
        'hospitalId': hospitalId,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Erro na requisição: ${res.body}');
    }

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    final retorno = RetornoGuiaModel.fromJson(decodedBody);

    return retorno;
  } catch (e, stacktrace) {
    print('Error: $e\nstack: $stacktrace');
    rethrow;
  
  }
}


  // Obter Operadoras
  Future<List<Map<String, dynamic>>> getOperadoras() async {
    try {
      final url = Uri.https('fila.wiremockapi.cloud', '/operadoras');
      final res = await client.get(url);

      if (res.statusCode != 200) {
        throw Exception('Erro na requisição: ${res.statusCode}');
      }

      final body = utf8.decode(res.bodyBytes);
      final Map<String, dynamic> decodedBody = json.decode(body);

      if (!decodedBody.containsKey('operadoras') ||
          decodedBody['operadoras'] is! List) {
        throw Exception('Estrutura da resposta inválida');
      }

      return List<Map<String, dynamic>>.from(decodedBody['operadoras']);
    } catch (e, stackTrace) {
      print('Erro em getOperadoras: $e');
      print(stackTrace);
      throw Exception('Erro ao buscar operadoras');
    }
  }

Future<List<Especialidade>> getEspecialidades() async {
  try {
    final url = Uri.https('fila.wiremockapi.cloud', '/especialidades');
    final res = await client.get(url);

    if (res.statusCode != 200) {
      throw Exception('Erro na requisição: ${res.statusCode}');
    }

    final body = utf8.decode(res.bodyBytes);
    final Map<String, dynamic> decodedBody = json.decode(body);

    // Verificar se a chave 'especialidades' está presente e é uma lista
    if (!decodedBody.containsKey('especialidades') ||
        decodedBody['especialidades'] is! List) {
      throw Exception('Estrutura da resposta inválida');
    }

    // Mapeia a lista de especialidades para uma lista de objetos Especialidade
    final List<Especialidade> especialidades =
        (decodedBody['especialidades'] as List)
            .map((e) => Especialidade.fromJson(e as Map<String, dynamic>))
            .toList();

    return especialidades;
  } catch (e, stackTrace) {
    print('Erro em getEspecialidades: $e');
    print(stackTrace);
    throw Exception('Erro ao buscar especialidades');
  }
}


  // Obter Informações do Usuário
  Future<Map<String, dynamic>> getUsuario() async {
    try {
      final url = Uri.https('fila.wiremockapi.cloud', '/usuario');
      final res = await client.get(url);

      if (res.statusCode != 200) {
        throw Exception('Erro na requisição: ${res.statusCode}');
      }

      final body = utf8.decode(res.bodyBytes);
      final Map<String, dynamic> decodedBody = json.decode(body);

      if (decodedBody.isEmpty) {
        throw Exception('Resposta vazia');
      }

      return decodedBody;
    } catch (e, stackTrace) {
      print('Erro em getUsuario: $e');
      print(stackTrace);
      throw Exception('Erro ao buscar informações do usuário');
    }
  }

  // Cadastrar Usuário
  Future<bool> cadastrarUsuario(Map<String, dynamic> usuarioData) async {
    try {
      final url = Uri.https('fila.wiremockapi.cloud', '/usuario');
      final res = await client.post(url, body: jsonEncode(usuarioData));

      if (res.statusCode != 201) {
        // Assumindo 201 como código de sucesso para criação
        throw Exception('Erro ao cadastrar usuário: ${res.statusCode}');
      }

      return true;
    } catch (e, stackTrace) {
      print('Erro em cadastrarUsuario: $e');
      print(stackTrace);
      throw Exception('Erro ao cadastrar usuário');
    }
  }

  // Realizar Autorização Guia
  Future<bool> realizarAutorizacaoGuia(Map<String, dynamic> guiaData) async {
    try {
      final url = Uri.https('fila.wiremockapi.cloud', '/autorizacaoGuia');
      final res = await client.post(url, body: jsonEncode(guiaData));

      if (res.statusCode != 200) {
        throw Exception('Erro ao realizar autorização: ${res.statusCode}');
      }

      return true;
    } catch (e, stackTrace) {
      print('Erro em realizarAutorizacaoGuia: $e');
      print(stackTrace);
      throw Exception('Erro ao realizar autorização de guia');
    }
  }


    Future<bool> enviaGuiaAssinada(int idGuia, String image) async {
    try {
      final url = Uri.https('fila.wiremockapi.cloud', '/guia/$idGuia');
      final res = await client.post(url, body: jsonEncode({'documentoAssinadoBase64': image}));

      if (res.statusCode != 200) {
        return false;
        throw Exception('Erro ao realizar autorização: ${res.statusCode}');

      }

      return true;
    } catch (e, stackTrace) {
      print('Erro em realizarAutorizacaoGuia: $e');
      print(stackTrace);
      throw Exception('Erro ao realizar autorização de guia');
    }
  }
}
