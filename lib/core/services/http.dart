import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class HttpClient extends http.BaseClient {

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {

    // final firebaseToken = await firebaseAuth.getToken(refresh: false);

    // if (firebaseToken != null) {
    //   request.headers.putIfAbsent('firebaseToken', () => firebaseToken);
   // }

   // safePrint('sending a ${request.method} to ${request.url}');

    return request.send();
  }
}
