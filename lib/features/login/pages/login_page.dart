import 'package:app_mock/core/colors';
import 'package:app_mock/core/widgets/custom_text_field.dart';
import 'package:app_mock/core/widgets/outline_buttom.dart';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    this.fromEditoria = false,
    super.key,
  });
  final bool fromEditoria;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Modular.get<LoginController>();
  bool chkSalvar = false;
  double cpWidth = 500;
  bool _obscureText = true;
  final _formKeyLogin = GlobalKey<FormState>();
  final TextEditingController emailLoginTextEditingController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  ValueNotifier<bool> showLogin = ValueNotifier(false);

@override
void initState() {
  controller.getLoginWithBio(context);
  super.initState();
}

@override
void dispose() {
  emailLoginTextEditingController.dispose();
  passwordController.dispose();
  passwordFocusNode.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.getThemeColor(
          darkColor.grayBackground, lightColor.background),
      child: Scaffold(
        backgroundColor:
            AppColor.getThemeColor(darkColor.background, lightColor.background),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: _formKeyLogin,
              child: Column(
                children: [
                  const SizedBox(height: 130),
                  Image.asset(
                    'assets/logo2.png',
                    height: 200,
                  ),

                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomTextField(
                      labelText: 'CPF',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: emailLoginTextEditingController,
                      hintText: 'CPF',
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      validator: (e) {
                        if (e == null || e.isEmpty) {
                          return 'Campo obrigatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomTextField(
                      labelText: 'Senha',
                      hintText: 'Senha',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      obscureText: _obscureText,
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () async {
                        if (_formKeyLogin.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      validator: (e) {
                        if (e == null || e.isEmpty) {
                          return 'Campo obrigatorio';
                        }
                        return null;
                      },
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      suffixIcon: IconButton(
                        icon: _obscureText
                            ? Icon(Icons.visibility_off_outlined,
                                color: Colors.grey)
                            : Icon(Icons.remove_red_eye_outlined,
                                color: Colors.grey),
                        color: Colors.black45,
                        onPressed: () => {
                          setState(() {
                            _obscureText = !_obscureText;
                          })
                        },
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     style: TextButton.styleFrom(
                  //       padding: const EdgeInsets.all(0),
                  //     ),
                  //     onPressed: () {
                  //       Modular.to.pushNamed(
                  //           AppRoutes.login + AppRoutes.forgotPassword);
                  //     },
                  //     child: Text(
                  //       'Esqueceu sua senha?',
                  //       style: AppText.lato14normal600(
                  //           darkColor.brandPrimary,
                  //           lightColor.brandPrimary),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GradientText(
                          'Habilitar biometria',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                          ),
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(0, 109, 119, 1),
                            Color.fromRGBO(131, 197, 190, 1),
                          ]),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: controller.checkBiometria,
                        builder: (context, value, child) {
                          return FlutterSwitch(
                            activeColor: AppColor.getThemeColor(
                                darkColor.background,
                                lightColor.grayBackground),
                            inactiveColor: AppColor.getThemeColor(
                                darkColor.background,
                                lightColor.grayBackground),
                            activeToggleColor: AppColor.getThemeColor(
                                darkColor.brandTertiary,
                                lightColor.brandTertiary),
                            inactiveToggleColor: AppColor.getThemeColor(
                                darkColor.grayBackground,
                                lightColor.brandTertiary),
                            height: 16,
                            width: 36,
                            toggleSize: 16,
                            value: value,
                            padding: 0,
                            onToggle: (val) {
                              controller.checkBiometria.value = val;
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  ValueListenableBuilder(
                    valueListenable: controller.isLoading,
                    builder: (context, value, child) {
                      if (value) {
                        // return const LoadingScreen();
                      }

                      return Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: MyOutlinedButton(
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (!_formKeyLogin.currentState!.validate()) {
                                  return;
                                }

                                // controller.login(
                                //   emailLoginTextEditingController.text,
                                //   passwordController.text,
                                //   context,
                                // );
                                    Modular.to.pushNamed('base');
                              },
                              gradient: const LinearGradient(colors: [
                                Color.fromRGBO(0, 109, 119, 1),
                                Color.fromRGBO(131, 197, 190, 1),
                              ]),
                              backgroundColor: Colors.transparent,
                              thickness: 2,
                              style: const ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent)),
                              child: Text(
                                'Entrar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Container(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        Modular.to.pushNamed(
                          'primeiro-acesso',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Cor de fundo branco
                        overlayColor: darkColor
                            .brandPrimary, // Cor do overlay ao pressionar
                        side: BorderSide(
                            color: Color.fromRGBO(0, 109, 119, 1),
                            width: 2), // Borda verde
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Borda arredondada de 10
                        ),
                      ),
                      child: Text(
                        'Primeiro acesso',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 109, 119, 1),
                        ),
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
