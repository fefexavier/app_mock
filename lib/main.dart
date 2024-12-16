import 'package:app_mock/features/login/login_module.dart';
import 'package:app_mock/src/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

  // Encontra o diretório onde os dados serão armazenados
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  //await Firebase.initializeApp();

  return runApp(ModularApp(module: LoginModule(), child:  AppWidget()));
}





