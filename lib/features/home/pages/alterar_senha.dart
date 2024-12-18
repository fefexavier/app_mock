import 'dart:convert';
import 'dart:io';

import 'package:app_mock/core/colors';
import 'package:app_mock/core/widgets/outline_buttom.dart';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/repositories/local_storage.dart';


class AlterarSEnhaPage extends StatefulWidget {
  const AlterarSEnhaPage({
    super.key,
  });
  @override
  State<AlterarSEnhaPage> createState() =>
      _AlterarSEnhaPageState();
}

class _AlterarSEnhaPageState extends State<AlterarSEnhaPage>
    with AutomaticKeepAliveClientMixin {
  final _formKeyacesso = GlobalKey<FormState>();

     final ILocalStorage storage = Modular.get();

final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Validação da senha atual
  String? currentPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    // Lógica de validação da senha atual, por exemplo
    // Adicione aqui a validação de senha atual, se necessário
    return null;
  }

  // Validação da nova senha
  String? newPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value.length < 8) {
      return 'A nova senha deve ter pelo menos 8 caracteres';
    }
    return null;
  }

  // Validação para confirmar a nova senha
  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value != newPasswordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  // Função para alterar a senha
  void _changePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aqui você deve implementar a lógica de alteração de senha
      // Como, por exemplo, fazer uma requisição para o backend
      // Para fins de exemplo, apenas mostraremos um sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha alterada com sucesso!')),
      );
    }
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: lightColor.brandPrimary,
              elevation: currentTheme.getIsDarkTheme() ? 0 : 2,
              shadowColor: Colors.grey[50],
              title: GradientText(
                'Alterar senha',
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(250, 251, 251, 1),
                  Color.fromRGBO(131, 197, 190, 1),
                ]),
              ),
              centerTitle: true,
              snap: true,
              floating: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: lightColor.brandPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: lightColor.grayBackground.withOpacity(0.3),
                        spreadRadius: 1.2,
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              surfaceTintColor:
                  AppColor.getThemeColor(darkColor.background, Colors.white),
              foregroundColor: currentTheme.getIsDarkTheme()
                  ? darkColor.background
                  : Colors.white,
            ),
          ];
        },
        body: SingleChildScrollView(
          child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo Senha Atual
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha Atual',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: currentPasswordValidator,
                ),
                const SizedBox(height: 20),
                
                // Campo Nova Senha
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Nova Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: newPasswordValidator,
                ),
                const SizedBox(height: 20),
                
                // Campo Confirmar Nova Senha
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Nova Senha',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: confirmPasswordValidator,
                ),
                const SizedBox(height: 30),
                
                // Botão para alterar senha
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    child: Text('Alterar Senha', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:lightColor.brandPrimary, 
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        ),
      ),
    );
  }
}
