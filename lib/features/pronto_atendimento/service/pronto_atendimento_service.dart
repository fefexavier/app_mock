import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_mock/core/repositories/local_storage.dart';
import 'package:app_mock/core/services/http.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/especialidade_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/hospital_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class AtendimentoRepository {
  AtendimentoRepository(this.client);
  final HttpClient client;
    final ILocalStorage storage = Modular.get();

  // Obter Hospitais
  Future<List<Hospital>> getHospitais() async {
    try {
      final url = Uri.https('fila-app-two.vercel.app', '/hospital');
      final res = await client.get(url,
        headers: {
          'Authorization': 'Bearer ${await storage.getToken()}',
          'Content-Type': 'application/json',
        },);

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }

      if (res.statusCode != 200) {
        throw Exception('Erro na requisição: ${res.statusCode}');
      }

      final body = utf8.decode(res.bodyBytes);
      final List<dynamic> decodedBody = json.decode(body);

      return decodedBody
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
    var jwtToken = await storage.getDecodedToken();
    if(jwtToken == null){
      throw Exception('Erro token');
    }

    final url = Uri.https('fila-app-two.vercel.app', '/autorizacao');
    
    // Enviando a requisição POST
    final res = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${await storage.getToken()}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'especialidadeId': especialidadeId,
        'hospitalId': hospitalId,
      }),
    );

    if (res.statusCode == 401) {
      Modular.to.pushNamed('/');
    }

    if (res.statusCode != 201) {
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
      final url = Uri.https('fila-app-two.vercel.app', '/operadoras');
      final res = await client.get(url,
        headers: {
          'Authorization': 'Bearer ${await storage.getToken()}',
          'Content-Type': 'application/json',
        });

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }

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
    final url = Uri.https('fila-app-two.vercel.app', '/especialidades');
    final res = await client.get(url,
      headers: {
        'Authorization': 'Bearer ${await storage.getToken()}',
        'Content-Type': 'application/json',
      });

    if (res.statusCode == 401) {
      Modular.to.pushNamed('/');
    }

    if (res.statusCode != 200) {
      throw Exception('Erro na requisição: ${res.statusCode}');
    }

    final body = utf8.decode(res.bodyBytes);
    final List<dynamic> decodedBody = json.decode(body);

    return decodedBody
            .map((e) => Especialidade.fromJson(e as Map<String, dynamic>))
            .toList();

  } catch (e, stackTrace) {
    print('Erro em getEspecialidades: $e');
    print(stackTrace);
    throw Exception('Erro ao buscar especialidades');
  }
}


  // Obter Informações do Usuário
  Future<Map<String, dynamic>> getUsuario() async {
    try {
      final url = Uri.https('fila-app-two.vercel.app', '/usuario');
      final res = await client.get(url,
        headers: {
          'Authorization': 'Bearer ${await storage.getToken()}',
          'Content-Type': 'application/json',
        },);

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }

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


  // Realizar Autorização Guia
  Future<bool> realizarAutorizacaoGuia(Map<String, dynamic> guiaData) async {
    try {
      final url = Uri.https('fila-app-two.vercel.app', '/autorizacaoGuia');
      final res = await client.post(url,
        headers: {
          'Authorization': 'Bearer ${await storage.getToken()}',
          'Content-Type': 'application/json',
        }, body: jsonEncode(guiaData));

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }

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


  Future<bool> enviaGuiaAssinada(int idGuia, String documento, String selfie) async {
    try {
      final url = Uri.https('fila-app-two.vercel.app', '/guia/$idGuia');

      final request = http.MultipartRequest('POST', url);

      request.fields['documentoAssinadoBase64'] = documento ?? '';
      request.fields['selfie'] = selfie ?? '';

      request.headers['Authorization'] = 'Bearer ${await storage.getToken()}';

      final res = await request.send();

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }

      if (res.statusCode != 200) {
        return false;
        throw Exception('Erro ao realizar autorização: ${res.statusCode}');

      }

      final resBody = await res.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = json.decode(resBody);

      // Extract the qrCode value
      if (jsonResponse.containsKey('qrCode')) {
        String qrCode = jsonResponse['qrCode'] as String;
      } else {
        throw Exception('QR Code not found in response');
      }

      return true;
    } catch (e, stackTrace) {
      print('Erro em realizarAutorizacaoGuia: $e');
      print(stackTrace);
      throw Exception('Erro ao realizar autorização de guia');
    }
  }

  // Obter Informações da guia pelo ID
  Future<Guia> getGuiaInfo(int guiaID) async {
    try {
      final url = Uri.https('fila-app-two.vercel.app', '/guia/$guiaID');
      final res = await client.get(url,
        headers: {
          'Authorization': 'Bearer ${await storage.getToken()}',
          'Content-Type': 'application/json',
        },);

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }

      if (res.statusCode != 200) {
        throw Exception('Erro na requisição: ${res.statusCode}');
      }

      final body = utf8.decode(res.bodyBytes);
      final Map<String, dynamic> decodedBody = json.decode(body);

      if (decodedBody.isEmpty) {
        throw Exception('Resposta vazia');
      }

      return Guia.fromJson(decodedBody);
    } catch (e, stackTrace) {
      print('Erro em getGuia: $e');
      print(stackTrace);
      throw Exception('Erro ao buscar informações da guia');
    }
  }

  Future<List<Guia>> getGuias() async {
    try {
      final url = Uri.https('fila-app-two.vercel.app', '/guias');
      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${await storage.getToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }
      if (res.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(res.body);
        return jsonResponse.map((guia) => Guia.fromJson(guia)).toList();
      } else {
        throw Exception('Falha ao carregar guias: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<void> downloadPdf(int guiaId,String savePath) async {
    try {
      // Faz a requisição GET com autenticação
      final url = Uri.https('fila-app-two.vercel.app', '/guia/$guiaId/document');
      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${await storage.getToken()}',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 401) {
        Modular.to.pushNamed('/');
      }

      if (res.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(res.bodyBytes);

        print('PDF salvo em: $savePath');
      } else {
        throw Exception('Falha ao baixar PDF: ${res.statusCode}');
      }
    } catch (e) {
      print('Erro ao baixar PDF: $e');
    }
  }
}
