import 'package:app_mock/features/login/model/user_model.dart';

abstract class ILocalStorage {
  late Usuario user;
  //late String token;

  Future<Usuario?> getUser();

  Future<void> setUser(Usuario user);

  Future<void> clearUser();

  //Future<String?> getToken();
  //Future<String> setToken(String token);
  //Future<String> clearToken();

  Future<void> setLocalCity(String city);

  Future<String?> getLocalCity();
}
