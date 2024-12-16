import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_mock/features/login/model/user_model.dart';

abstract class ILocalStorage {
  Future<Usuario?> getUser();
  Future<void> setUser(Usuario user);
  Future<void> clearUser();
}

class LocalStorage implements ILocalStorage {
  final Completer<SharedPreferences> _instance = Completer<SharedPreferences>();

  @override
  Usuario user = Usuario();

  LocalStorage() {
    _init();
  }

  Future<void> _init() async {
    _instance.complete(await SharedPreferences.getInstance());
  }

  @override
  Future<Usuario?> getUser() async {
    final shared = await _instance.future;
    final String jsonUser = shared.getString('user') ?? '';
    if (jsonUser.isNotEmpty) {
      final Map<String, dynamic> userMap = json.decode(jsonUser);
      user = Usuario.fromJson(userMap);
      return user;
    }
    return null;
  }

  @override
  Future<void> setUser(Usuario user) async {
    final shared = await _instance.future;
    final String userJson = json.encode(user.toJson());
    await shared.setString('user', userJson);
    this.user = user;
  }

  @override
  Future<void> clearUser() async {
    final shared = await _instance.future;
    await shared.remove('user');
    user = Usuario();
  }
}
