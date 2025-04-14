import 'dart:convert';
import 'package:app_mock/core/colors';
import 'package:app_mock/core/services/app_enums.dart';
import 'package:app_mock/core/widgets/custom_text_field.dart';
import 'package:app_mock/core/widgets/loading_screen.dart';
import 'package:app_mock/core/widgets/outline_buttom.dart';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/login/controller/login_controller.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class PrimeiroAcessoPage extends StatefulWidget {
  const PrimeiroAcessoPage({super.key});

  @override
  State<PrimeiroAcessoPage> createState() => _PrimeiroAcessoPageState();
}

class _PrimeiroAcessoPageState extends State<PrimeiroAcessoPage>
    with AutomaticKeepAliveClientMixin {
  final _formKeyacesso = GlobalKey<FormState>();

  final TextEditingController nome = TextEditingController();
  final FocusNode nomeNode = FocusNode();
  final TextEditingController data = TextEditingController();
  final FocusNode dataNode = FocusNode();
  final TextEditingController cpf = TextEditingController();
  final FocusNode cpfNode = FocusNode();
  final TextEditingController cep = TextEditingController();
  final FocusNode cepNode = FocusNode();
  final TextEditingController endereco = TextEditingController();
  final FocusNode enderecoNode = FocusNode();
  final TextEditingController numeroEnd = TextEditingController();
  final FocusNode numeroEndNode = FocusNode();
  final TextEditingController complementoEnd = TextEditingController();
  final FocusNode complementoEndNode = FocusNode();
  final TextEditingController telefone = TextEditingController();
  final FocusNode telefoneNode = FocusNode();
  final TextEditingController email = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final TextEditingController plano = TextEditingController();
  final FocusNode planoNode = FocusNode();
  final TextEditingController ncarteira = TextEditingController();
  final FocusNode ncarteiraNode = FocusNode();

  final maskCpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final maskDataNascimentoFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final maskCepFormatter = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  final maskTelefoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final LoginController controller = Modular.get();

  @override
  void initState() {
    super.initState();
    controller.getOperadoras();
    cep.addListener(_onCepChanged);
  }

  void _onCepChanged() {
    if (cep.text.length == 9) {
      // Verifica se o CEP está completo (com máscara)
      _buscarEnderecoPorCep();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nome.dispose();
    data.dispose();
    cpf.dispose();
    cep.dispose();
    endereco.dispose();
    numeroEnd.dispose();
    complementoEnd.dispose();
    telefone.dispose();
    email.dispose();
    plano.dispose();
    ncarteira.dispose();

    nomeNode.dispose();
    dataNode.dispose();
    cpfNode.dispose();
    cepNode.dispose();
    enderecoNode.dispose();
    numeroEndNode.dispose();
    complementoEndNode.dispose();
    telefoneNode.dispose();
    emailNode.dispose();
    planoNode.dispose();
    ncarteiraNode.dispose();

    super.dispose();
  }

  void salvarUsuario() {
    if (_formKeyacesso.currentState!.validate()) {
      var operadoraSel = controller.operadoras.firstWhere((operadora) => operadora.nomeSocial == plano.text);

      final usuario = Usuario(
        cpf: cpf.text.replaceAll(RegExp(r'[^0-9]'), ''),
        nome: nome.text,
        dataNascimento: data.text,
        cep: cep.text,
        endereco: endereco.text,
        numeroEndereco: numeroEnd.text,
        complementoEndereco: complementoEnd.text,
        telefone: telefone.text,
        email: email.text,
        operadoraId: operadoraSel.id.toString(),
        numeroCarteira: ncarteira.text,
      );

      controller.setUser(usuario);
      Modular.to.pushNamed('primeiro-acesso-arquivo');
    }
  }

  Future<void> _buscarEnderecoPorCep() async {
    final cepValue = cep.text.replaceAll('-', '');
    final url = Uri.parse('https://viacep.com.br/ws/$cepValue/json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data.containsKey('logradouro')) {
          setState(() {
            endereco.text =
                '${data['logradouro']}, ${data['bairro']}, ${data['localidade']} - ${data['uf']}';
          });
        } else {
          _showSnackBar('CEP não encontrado');
        }
      } else {
        _showSnackBar('Erro ao buscar endereço');
      }
    } catch (e) {
      _showSnackBar('Erro de conexão');
    }
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
                    color: Colors.grey.withOpacity(0.5),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyacesso,
              child:
                ValueListenableBuilder<PaginateState>(
                    valueListenable: controller.stateOperadoras,
                    builder: (context, state, child) {
                      if (state == PaginateState.loading) {
                        return Column(
                          
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height *0.25,),
                            Center(child: const LoadingScreen()),
                          ],
                        );
                      } else if (state == PaginateState.error) {
                        return const Text('Erro ao carregar vídeos');
                      } else if (state == PaginateState.infinityLoading) {
                        return const LoadingScreen();
                      } else if (state == PaginateState.sucess) {
                        return  Column(
                children: [




                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'CPF',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: cpf,
                      hintText: 'CPF',
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskCpfFormatter],
                      validator: (e) =>
                          e == null || e.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Nome',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: nome,
                      hintText: 'Nome',
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      validator: (e) =>
                          e == null || e.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Data de nascimento',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: data,
                      hintText: 'Data de nascimento',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskDataNascimentoFormatter],
                      validator: (e) =>
                          e == null || e.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'CEP',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: cep,
                      hintText: 'CEP',
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskCepFormatter],
                      validator: (e) =>
                          e == null || e.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Endereço',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: endereco,
                      hintText: 'Endereço',
                      prefixIcon: Icon(
                        Icons.home,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Número',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: numeroEnd,
                      hintText: 'Número',
                      prefixIcon: Icon(
                        Icons.home,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (e) =>
                          e == null || e.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Complemento',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: complementoEnd,
                      hintText: 'Complemento',
                      prefixIcon: Icon(
                        Icons.home,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Telefone',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: telefone,
                      hintText: '(99) 99999-9999',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        maskTelefoneFormatter
                      ], // Aqui está o formatter
                      validator: (e) {
                        if (e == null || e.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        if (e.length != 15) {
                          // Verifica se o número está completo
                          return 'Número de telefone inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Email',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: email,
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (e) =>
                          e == null || e.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Plano de Saúde', style: TextStyle(fontSize: 16, color: lightColor.brandPrimary)),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: 'Selecione uma operadora',
          prefixIcon: Icon(
            Icons.health_and_safety,
            color: AppColor.getThemeColor(darkColor.brandPrimary, lightColor.brandPrimary),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(),
        ),
        value: plano.text.isNotEmpty ? plano.text : null,
        onChanged: (newValue) {
          plano.text = newValue!;
       
        },
        items: controller.operadoras.map((operadora) {
          return DropdownMenuItem<String>(
            value: operadora.nomeSocial,
            child: Text(operadora.nomeSocial),
          );
        }).toList(),
        validator: (e) => e == null || e.isEmpty ? 'Campo obrigatório' : null,
      ),
    ],
  ),
),


                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: CustomTextField(
                      labelText: 'Número da carteirinha',
                      hintStyle: TextStyle(color: lightColor.brandPrimary),
                      controller: ncarteira,
                      hintText: 'Número da carteirinha',
                      prefixIcon: Icon(
                        Icons.card_membership,
                        color: AppColor.getThemeColor(
                            darkColor.brandPrimary, lightColor.brandPrimary),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (e) =>
                          e == null || e.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: MyOutlinedButton(
                      onPressed: salvarUsuario,
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
              );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
              
              
              
              
              
              
              
            ),
          ),
        ),
      ),
    );
  }
}
