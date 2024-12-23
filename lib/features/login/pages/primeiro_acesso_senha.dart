import 'package:app_mock/core/colors';
import 'package:app_mock/core/repositories/local_storage.dart';
import 'package:app_mock/core/widgets/custom_text_field.dart';
import 'package:app_mock/core/widgets/outline_buttom.dart';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/login/controller/login_controller.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimeiroAcessoSenhaPage extends StatefulWidget {
  const PrimeiroAcessoSenhaPage({super.key});

  @override
  State<PrimeiroAcessoSenhaPage> createState() =>
      _PrimeiroAcessoSenhaPageState();
}

class _PrimeiroAcessoSenhaPageState extends State<PrimeiroAcessoSenhaPage>
    with AutomaticKeepAliveClientMixin {
  final _formKeyacesso = GlobalKey<FormState>();

  // Controladores para os campos de senha
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
        final controller = Modular.get<LoginController>();

  // FocusNodes para navegação entre os campos
  final FocusNode passwordNode = FocusNode();
  final FocusNode repeatPasswordNode = FocusNode();
       final ILocalStorage storage = Modular.get();

  @override
  void dispose() {
    // Certifique-se de descartar os controladores e FocusNodes corretamente
    passwordController.dispose();
    repeatPasswordController.dispose();
    passwordNode.dispose();
    repeatPasswordNode.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  // Validação personalizada para a senha
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    // Verifica se a senha tem pelo menos uma letra maiúscula, uma letra minúscula e um número
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(value)) {
      return 'A senha deve conter uma letra maiúscula, uma minúscula e um número';
    }
    return null;
  }

  // Validação para o campo "Repetir Senha"
  String? repeatPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value != passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }


  void salvarUsuarioComImagens(Usuario usuarioAtual) {

  final usuarioAtualizado = usuarioAtual.copyWith(
    senha: passwordController.value.text,
  
  );
  controller.setUser(usuarioAtualizado);
  // Exemplo: Enviar o usuário atualizado para o controller ou backend
  print(usuarioAtualizado.toJson());
}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: lightColor.brandPrimary,
              elevation: 2,
              shadowColor: Colors.grey[50],
              title: GradientText(
                'Primeiro acesso',
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
              foregroundColor: Colors.white,
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyacesso,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Para fazer o login, crie uma senha:",
                    style: TextStyle(color: lightColor.brandPrimary),
                  ),
                  const SizedBox(height: 10),
                  // Campo de senha
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomTextField(
                      labelText: 'Senha',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: passwordController,
                      hintText: 'Digite a senha',
                      obscureText: true,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: passwordNode,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(repeatPasswordNode);
                      },
                      validator: passwordValidator,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Campo de repetir senha
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomTextField(
                      labelText: 'Repetir Senha',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: repeatPasswordController,
                      hintText: 'Repita a senha',
                      obscureText: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: repeatPasswordNode,
                      validator: repeatPasswordValidator,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botão para prosseguir
                  SizedBox(
                    width: double.maxFinite,
                    child: MyOutlinedButton(
                      onPressed: () async{
                        // Remove o foco dos campos ao clicar no botão
                        FocusManager.instance.primaryFocus?.unfocus();

                        // Valida os campos do formulário
                        if (_formKeyacesso.currentState?.validate() ?? false) {
                          print("Formulário validado com sucesso!");

                       Usuario?  usuario =  await storage.getUser();
            salvarUsuarioComImagens(usuario!);
                          controller.saveUser();
                         // Modular.to.pushNamed('base');
                        } else {
                          print("Erro na validação do formulário");
                        }
                      },
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(0, 109, 119, 1),
                        Color.fromRGBO(131, 197, 190, 1),
                      ]),
                      backgroundColor: Colors.transparent,
                      thickness: 2,
                      style: const ButtonStyle(
                          overlayColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      child: Text(
                        'Prosseguir',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
