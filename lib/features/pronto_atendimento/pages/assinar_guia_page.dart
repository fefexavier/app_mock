import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:app_mock/core/colors';
import 'package:app_mock/core/repositories/local_storage.dart';
import 'package:app_mock/core/services/app_enums.dart';
import 'package:app_mock/core/widgets/loading_screen.dart';
import 'package:app_mock/core/widgets/outline_buttom.dart';
import 'package:app_mock/features/pronto_atendimento/controller/atendimento_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

class AssinarGuiaPage extends StatefulWidget {
  AtendimentoController controller;
  AssinarGuiaPage(this.controller, {super.key});

  @override
  State<AssinarGuiaPage> createState() => _AssinarGuiaPageState();
}

class _AssinarGuiaPageState extends State<AssinarGuiaPage>
    with AutomaticKeepAliveClientMixin {
  final _formKeyacesso = GlobalKey<FormState>();
final ILocalStorage storage = Modular.get();
  File? _selfie;
  File? _assinaturaFile;
  bool _downloadedPdf = false;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> _setSelfie(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selfie = File(pickedFile.path);
      });
    }
  }

  void _downloadPdf() {
    setState(() {
      _downloadedPdf = true;
    });
  }

  Future<void> _openSignatureModal() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Assine a Guia de Atendimento",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Signature(
                controller: _signatureController,
                height: 300,
                backgroundColor: Colors.grey[200]!,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _signatureController.clear(),
                    child: Text("Limpar"),
                    style: ElevatedButton.styleFrom(
                        shadowColor: lightColor.brandTertiary),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveAssinatura();
                      Navigator.pop(context); // Fecha o modal após salvar
                    },
                    child: Text("Salvar Assinatura"),
                    style: ElevatedButton.styleFrom(
                        shadowColor: lightColor.brandTertiary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAssinatura() async {
    if (_signatureController.isNotEmpty) {
      final signatureImage = await _signatureController.toImage();
      final byteData =
          await signatureImage!.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/assinatura.png';
        final file = File(filePath);
        await file.writeAsBytes(buffer);

        setState(() {
          _assinaturaFile = file;
        });
      }
    }
  }

  // Para File

  Future<String> fileToBase64(File file) async {
    // Lê o conteúdo do arquivo como bytes
    final fileBytes = await file.readAsBytes();

    // Converte os bytes para base64
    final base64String = base64Encode(fileBytes);

    return base64String;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKeyacesso,
          child: Column(
            children: [
              ValueListenableBuilder<PaginateState>(
                valueListenable: widget.controller.stateAutorizacao,
                builder: (context, state, child) {
                  if (state == PaginateState.loading) {
                    return const Column(
                      children: [
                        Center(child: LoadingScreen()),
                      ],
                    );
                  } else if (state == PaginateState.error) {
                    return const Text(
                        'Erro ao solicitar guia, entre emcontato com o plano de saúde');
                  } else if (state == PaginateState.start) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                        Text(
                          'Gere a Guia de Autorização do Plano',
                          style: TextStyle(
                              color: lightColor.brandSecondary, fontSize: 18),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Image.asset(
                          'assets/logo2.png',
                          height: 200,
                        ),
                      ],
                    );
                  } else if (state == PaginateState.infinityLoading) {
                    return const Column(
                      children: [
                        Center(child: LoadingScreen()),
                      ],
                    );
                  } else if (state == PaginateState.sucess) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
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
                                'Download da guia em PDF',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: lightColor.brandPrimary,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _downloadPdf,
                                icon: Icon(Icons.download),
                                label: Text(_downloadedPdf
                                    ? 'PDF Baixado'
                                    : 'Baixar PDF'),
                                style: ElevatedButton.styleFrom(
                                    shadowColor: lightColor.brandTertiary),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Campo de assinatura manual
                        Container(
                          width: double.infinity,
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
                                'Assine a Guia de Atendimento',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: lightColor.brandPrimary,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _openSignatureModal,
                                child: Text("Abrir Assinatura"),
                                style: ElevatedButton.styleFrom(
                                    shadowColor: lightColor.brandTertiary),
                              ),
                              if (_assinaturaFile != null) ...[
                                SizedBox(height: 16),
                                Text("Assinatura Salva:"),
                                Image.file(
                                  _assinaturaFile!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Campo de selfie
                        Container(
                          width: double.infinity,
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
                                        Icons.camera_alt,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                                    ),
                              SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => _setSelfie(ImageSource.camera),
                                icon: Icon(Icons.camera),
                                label: Text('Tirar Selfie'),
                                style: ElevatedButton.styleFrom(
                                    shadowColor: lightColor.brandTertiary),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Botão de prosseguir
                        SizedBox(
                          width: double.maxFinite,
                          child: MyOutlinedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              /// Valida se o PDF foi baixado (se for obrigatório)

                              /// Valida se o usuário fez a selfie
                              if ( _assinaturaFile == null || _selfie == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, tire a selfie  e assine antes de prosseguir.'),
                                  ),
                                );
                                return;
                              } else {
                                widget.controller.qrcode.assinaturaGuia =  await fileToBase64(_assinaturaFile!);
                                widget.controller.qrcode.selfieGuia = await fileToBase64(_selfie!);
                                widget.controller.qrcode.idGuia = widget.controller.guia.idGuia!;

                                final usuario = await storage.getUser();
                                widget.controller.qrcode.idUsuario = usuario!.cpf!;
                                String file = await fileToBase64(_assinaturaFile!);
                                String selfie = await fileToBase64(_selfie!);
                                widget.controller.enviaGuiaAssinada( widget.controller.guia.idGuia!, file, selfie);
                                widget.controller.tabController!.animateTo(2);
                              }

                              /// Se tudo estiver OK, avança para a próxima rota
                            },
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(0, 109, 119, 1),
                              Color.fromRGBO(131, 197, 190, 1),
                            ]),
                            backgroundColor: Colors.transparent,
                            thickness: 2,
                            style: const ButtonStyle(
                              overlayColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                            ),
                            child: const Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
