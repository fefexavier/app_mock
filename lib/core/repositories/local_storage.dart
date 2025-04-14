import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_mock/features/login/model/user_model.dart';

extension JwtDecoder on String {
  JwtPayload decodeJwt() {
    final parts = split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid JWT token');
    }

    final payload = parts[1];
    final normalizedPayload = base64.normalize(payload);
    final decodedPayload = utf8.decode(base64.decode(normalizedPayload));
    final payloadMap = json.decode(decodedPayload) as Map<String, dynamic>;

    return JwtPayload.fromJson(payloadMap);
  }
}

abstract class ILocalStorage {
  Future<Usuario?> getUser();
  Future<void> setUser(Usuario user);
  Future<void> clearUser();
  Future<String?> getToken();
  Future<void> setToken(String token);
  Future<void> clearToken();
  Future<JwtPayload?> getDecodedToken();
}

class LocalStorage implements ILocalStorage {
  final Completer<SharedPreferences> _instance = Completer<SharedPreferences>();

  @override
  Usuario user = Usuario();
  String token = ""; // TODO: verificar se precisa ficar instaciado na classe

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

  @override
  Future<String?> getToken() async {
    final shared = await _instance.future;
    final String token = shared.getString('token') ?? '';
    if (token.isNotEmpty) {
      return token;
    }
    return null;
  }

  @override
  Future<void> setToken(String token) async {
    final shared = await _instance.future;
    await shared.setString('token', token);
    this.token = token;
  }

  @override
  Future<void> clearToken() async {
    final shared = await _instance.future;
    await shared.remove('token');
    this.token = "";
  }

  @override
  Future<JwtPayload?> getDecodedToken() async {
    try {
      final token = await getToken();
      if (token == null) return null;
      return token.decodeJwt();
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }
}
