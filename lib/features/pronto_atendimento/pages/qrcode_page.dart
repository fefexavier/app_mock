import 'package:app_mock/core/colors';
import 'package:flutter/material.dart';

class QrcodePage extends StatefulWidget {
  const QrcodePage({super.key});

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text("Seu QR code com a guia de autorização liberada está pronto! Agora direja-se ao hospital", style: TextStyle(color: lightColor.brandPrimary),),
    ),
          Image.asset(
                    'assets/qrcode.png',
                    height: 500,
                  ),

                  
    
    
    
    ],);
  }
}