import 'package:app_mock/features/login/model/user_model.dart';

abstract class ILocalStorage {
  late Usuario user;

  Future<Usuario?> getUser();

  Future<void> setUser(Usuario user);

  Future<void> clearUser();

  Future<void> setLocalCity(String city);

  Future<String?> getLocalCity();
}
