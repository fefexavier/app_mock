import 'dart:convert';
import 'dart:io';

import 'package:app_mock/core/colors';
import 'package:app_mock/core/widgets/outline_buttom.dart';
import 'package:app_mock/core/widgets/text.dart';
import 'package:app_mock/features/login/controller/login_controller.dart';
import 'package:app_mock/features/login/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/repositories/local_storage.dart';


class PrimeiroAcessoArquivoPage extends StatefulWidget {
  const PrimeiroAcessoArquivoPage({
    super.key,
  });
  @override
  State<PrimeiroAcessoArquivoPage> createState() =>
      _PrimeiroAcessoArquivoPageState();
}

class _PrimeiroAcessoArquivoPageState extends State<PrimeiroAcessoArquivoPage>
    with AutomaticKeepAliveClientMixin {
  final _formKeyacesso = GlobalKey<FormState>();

     final ILocalStorage storage = Modular.get();
  final LoginController controller = Modular.get();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  File? _image;
  File? _carteirinha;
  File? _selfie;

  Future<void> _setSelfie(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selfie = File(pickedFile.path);
      });
    }
  }

void salvarUsuarioComImagens(Usuario usuarioAtual) {
  final imagemPerfilBase64 = convertFileToBase64(_selfie);
  final documentoAssinadoBase64 = convertFileToBase64(_image);
  final comprovanteResidenciaBase64 = convertFileToBase64(_carteirinha);

  final usuarioAtualizado = usuarioAtual.copyWith(
    imagemPerfil: imagemPerfilBase64,
    documentoAssinado: documentoAssinadoBase64,
    comprovanteResidencia: comprovanteResidenciaBase64,
  );
  

   controller.setUser(usuarioAtualizado);
  // Exemplo: Enviar o usuário atualizado para o controller ou backend
  print(usuarioAtualizado.toJson());
}


String? convertFileToBase64(File? file) {
  if (file == null) return null;
  final bytes = file.readAsBytesSync();
  return base64Encode(bytes);
}


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _validateImages() {
    if (_image == null) {
      _showSnackBar('Por favor, envie um documento com foto.');
      return false;
    }
    if (_carteirinha == null) {
      _showSnackBar('Por favor, envie a carteirinha do convênio.');
      return false;
    }
    if (_selfie == null) {
      _showSnackBar('Por favor, envie uma selfie.');
      return false;
    }
    return true;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> setCarteirinha(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _carteirinha = File(pickedFile.path);
      });
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyacesso,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: lightColor.brandPrimary, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Documento com Foto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightColor.brandPrimary,
                          ),
                        ),
                        SizedBox(height: 16),
                        _image != null
                            ? Image.file(
                                _image!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: Icon(Icons.camera),
                              label: Text('Câmera'),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: lightColor.brandTertiary),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: Icon(Icons.photo_library),
                              label: Text('Galeria'),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: lightColor.brandTertiary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: lightColor.brandPrimary, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carteirinha do Convênio',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightColor.brandPrimary,
                          ),
                        ),
                        SizedBox(height: 16),
                        _carteirinha != null
                            ? Image.file(
                                _carteirinha!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  setCarteirinha(ImageSource.camera),
                              icon: Icon(Icons.camera),
                              label: Text('Câmera'),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: lightColor.brandTertiary),
                            ),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  setCarteirinha(ImageSource.gallery),
                              icon: Icon(Icons.photo_library),
                              label: Text('Galeria'),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: lightColor.brandTertiary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: lightColor.brandPrimary, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selfie',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightColor.brandPrimary,
                          ),
                        ),
                        SizedBox(height: 16),
                        _selfie != null
                            ? Image.file(
                                _selfie!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _setSelfie(ImageSource.camera),
                              icon: Icon(Icons.camera),
                              label: Text('Câmera'),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: lightColor.brandTertiary),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _setSelfie(ImageSource.gallery),
                              icon: Icon(Icons.photo_library),
                              label: Text('Galeria'),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: lightColor.brandTertiary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: MyOutlinedButton(
                      onPressed: () async{
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (!_validateImages()) {
                          return;
                        }

                        if (!_formKeyacesso.currentState!.validate()) {
                          return;
                        }

 
   Usuario?  usuario =  await storage.getUser();
            salvarUsuarioComImagens(usuario!);
                        Modular.to.pushNamed(
                          'primeiro-acesso-senha',
                        );
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
