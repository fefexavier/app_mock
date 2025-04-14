import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Hospital {
  final int id;
  final String nome;
  final String endereco;

  Hospital({
    required this.id,
    required this.nome,
    required this.endereco,
  });

  // Método para converter de JSON para Hospital
  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
    );
  }

  // Método para converter Hospital para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
    };
  }
}
