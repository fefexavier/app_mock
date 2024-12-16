import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Hospital {
  final String id;
  final String nome;
  final String cnpj;
  final String endereco;
  final String statusOperacao;
  final List<String> tiposAtendimento;
  final List<Map<String, String>> operadorasPlanoSaude;

  Hospital({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.endereco,
    required this.statusOperacao,
    required this.tiposAtendimento,
    required this.operadorasPlanoSaude,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      nome: json['nome'],
      cnpj: json['cnpj'],
      endereco: json['endereco'],
      statusOperacao: json['statusOperacao'],
      tiposAtendimento:
          List<String>.from(json['tiposAtendimento'] ?? []),
      operadorasPlanoSaude: List<Map<String, String>>.from(
        json['operadorasPlanoSaude']?.map((e) => Map<String, String>.from(e)) ??
            [],
      ),
    );
  }
}
