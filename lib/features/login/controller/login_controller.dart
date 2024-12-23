// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:app_mock/core/services/app_enums.dart';
import 'package:app_mock/core/services/authentication.dart';
import 'package:app_mock/features/login/login_service/login_service.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';

import '../../../core/repositories/local_storage.dart';

class LoginController {
  final repository = Modular.get<LoginService>();

  ValueNotifier<bool> checkBiometria = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ILocalStorage storage = Modular.get();
  List<OperadoraPlanoSaude> operadoras = [];
  ValueNotifier<PaginateState> stateOperadoras =
      ValueNotifier(PaginateState.start);
  // AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  Future<void> saveUser() async {
    await repository.cadastrarUsuario();
  }

  Future<void> getLoginWithBio(BuildContext context) async {
    final box = await Hive.openBox('loginbox');
    var teste = box.get('biometria');
    checkBiometria.value = box.get('biometria') ?? false;

    // if (checkBiometria.value) {
    //   final bool logar = await _localAuth();
    //   if (logar) {
    //     final user = box.get('user');
    //     final pass = box.get('pass');
    //     await login(user, pass, context);
    //   }
    // }
    await box.close();
  }

  Future<List<OperadoraPlanoSaude>> getOperadoras() async {
    stateOperadoras.value = PaginateState.loading;

    try {
      operadoras = await repository.getPlanos();
      stateOperadoras.value = PaginateState.sucess;
    } catch (e) {
      stateOperadoras.value = PaginateState.error;
      log('Erro ao buscar operadoras: $e');
    }

    return operadoras;
  }

  setUser(Usuario user) {
    storage.setUser(user);
  }
  // Future<bool> _localAuth() async {
  //   try {
  //     bool authenticated = await auth.authenticate(
  //         localizedReason:
  //             'Realize o login para ter acesso a todos seus beneficios',
  //         options: const AuthenticationOptions(
  //           stickyAuth: true,
  //         ));

  //     return authenticated;
  //   } catch (e, stackTrace) {
  //     unawaited(
  //       FirebaseCrashlytics.instance.recordError(e, stackTrace,
  //           reason: 'Erro inesperado no _localAuth do login_controller'),
  //     );
  //     return false;
  //   }
  // }

  Future<void> login(String login, String pass, BuildContext context) async {
    // isLoading.value = true;
    // final result = await cognito.signInUser(login, pass);

    // if (result.error == null) {
    //   await saveUser();

    //   if (checkBiometria.value) {
    //     await saveLocalLogin(login, pass);
    //   } else {
    //     await clearLocalLogin();
    //   }

    //   await storage.getUser();
    //   isLoading.value = false;

    //   if (storage.user.subscriber) {
    //     unawaited(Modular.to.pushNamed(AppRoutes.newspaper));
    //   } else {
    //     unawaited(Modular.to.pushReplacementNamed('${AppRoutes.base}otplus/'));
    //   }
    // } else {
    //   isLoading.value = false;
    //   unawaited(
    //     AppAlerts.basic(
    //       context,
    //       'Login',
    //       result.error?.message,
    //       AlertType.alert,
    //     ),
    //   );
    // }
  }

  // Future<void> loginSocial(AuthProvider provider, BuildContext context) async {
  //   isLoading.value = true;
  //   final result = await cognito.socialSignIn(provider);

  //   if (result.error == null) {
  //     await saveUser();
  //     await storage.getUser();
  //     isLoading.value = false;

  //     unawaited(Modular.to.pushReplacementNamed('${AppRoutes.base}otplus/'));
  //   } else {
  //     isLoading.value = false;

  //     unawaited(
  //       AppAlerts.basic(
  //         context,
  //         'Login',
  //         result.error?.message,
  //         AlertType.alert,
  //       ),
  //     );
  //   }
  // // }

  // Future<void> saveUser() async {
  //   await storage.setUser(User());

  //   final session = await cognito.getSession();

  //   if (session.isSignedIn) {
  //     storage.user.acessToken =
  //         session.userPoolTokensResult.value.accessToken.toJson();
  //     storage.user.idToken =
  //         session.userPoolTokensResult.value.idToken.toJson();
  //     storage.user.refreshToken =
  //         session.userPoolTokensResult.value.refreshToken;
  //   }

  //   final User user =
  //       await serivce.getMeuPerfilUser(storage.user.idToken ?? '');

  //   user
  //     ..acessToken = storage.user.acessToken
  //     ..idToken = storage.user.idToken
  //     ..refreshToken = storage.user.refreshToken;

  //   await storage.setUser(user);

  //   if (!revalidadeToken.renovaTokenRunning) {
  //     unawaited(revalidadeToken.renovaToken());
  //   }
  // }

  // Future<void> saveLocalLogin(String user, String pass) async {
  //   final box = await Hive.openBox('loginBox');

  //   await box.putAll({'user': user, 'pass': pass, 'biometria': true});
  //   bool teste = box.get('biometria');
  //   await box.close();
  // }

  // Future<void> clearLocalLogin() async {
  //   final box = await Hive.openBox('loginBox');
  //   await box.clear();
  //   await box.close();
  // }

 
}
