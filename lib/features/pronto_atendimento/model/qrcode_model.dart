import 'package:app_mock/features/pronto_atendimento/model/especialidade_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/hospital_model.dart';

class  QrCodeModel {
     Hospital? hospital;
     Especialidade? especialidade;
     String idUsuario;
     int idGuia;
     String imageGuia;
     String selfieGuia;
     String assinaturaGuia;

   QrCodeModel({
    required this.hospital,
    required this.especialidade,
    required this.idUsuario,
    required this.idGuia,
    required this.imageGuia,
    required this.selfieGuia,
    required this.assinaturaGuia,
  });

  // Método copyWith
   QrCodeModel copyWith({
    Hospital? hospital,
    Especialidade? especialidade,
    String? idUsuario,
    int? idGuia,
    String? imageGuia,
    String? selfieGuia,
    String? assinaturaGuia,
  }) {
    return  QrCodeModel(
      hospital: hospital ?? this.hospital,
      especialidade: especialidade ?? this.especialidade,
      idUsuario: idUsuario ?? this.idUsuario,
      idGuia: idGuia ?? this.idGuia,
      imageGuia: imageGuia ?? this.imageGuia,
      selfieGuia: selfieGuia ?? this.selfieGuia,
      assinaturaGuia: assinaturaGuia ?? this.assinaturaGuia,
    );
  }

  // Método para converter de JSON para  QrCodeModel
  factory  QrCodeModel.fromJson(Map<String, dynamic> json) {
    return  QrCodeModel(
      hospital: Hospital.fromJson(json['hospital']),
      especialidade: Especialidade.fromJson(json['especialidade']),
      idUsuario: json['idUsuario'],
      idGuia: json['idGuia'],
      imageGuia: json['imageGuia'],
      selfieGuia: json['selfieGuia'],
      assinaturaGuia: json['assinaturaGuia'],
    );
  }

  // Método para converter  QrCodeModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'hospital': hospital?.toJson(),
      'especialidade': especialidade?.toJson(),
      'idUsuario': idUsuario,
      'idGuia': idGuia,
      'imageGuia': imageGuia,
      'selfieGuia': selfieGuia,
      'assinaturaGuia': assinaturaGuia,
    };
  }
}
