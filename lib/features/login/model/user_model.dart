import 'dart:convert';

class Usuario {
  final String? cpf;
  final String? nome;
  final String? dataNascimento;
  final String? cep;
  final String? endereco;
  final String? numeroEndereco;
  final String? complementoEndereco;
  final String? telefone;
  final String? email;
  final String? planoSaude;
  final String? numeroCarteira;
  final String? imagemPerfil; 
  final String? documentoAssinado; 
  final String? comprovanteResidencia; 
   final String? senha ;



  Usuario({
     this.cpf,
     this.nome,
     this.dataNascimento,
     this.cep,
     this.endereco,
     this.numeroEndereco,
     this.complementoEndereco,
     this.telefone,
     this.email,
     this.planoSaude,
     this.numeroCarteira,
    this.imagemPerfil,
    this.documentoAssinado,
    this.comprovanteResidencia,
   this.senha
  
  });


  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'dataNascimento': dataNascimento,
      'cep': cep,
      'endereco': endereco,
      'numeroEndereco': numeroEndereco,
      'complementoEndereco': complementoEndereco,
      'telefone': telefone,
      'email': email,
      'planoSaude': planoSaude,
      'numeroCarteira': numeroCarteira,
      'imagemPerfil': imagemPerfil,
      'documentoAssinado': documentoAssinado,
      'comprovanteResidencia': comprovanteResidencia,
       'senha': senha,
    };
  }


  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      cpf: json['cpf'] as String,
      nome: json['nome'] as String,
      dataNascimento: json['dataNascimento'] as String,
      cep: json['cep'] as String,
      endereco: json['endereco'] as String,
      numeroEndereco: json['numeroEndereco'] as String,
      complementoEndereco: json['complementoEndereco'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      planoSaude: json['planoSaude'] as String,
      numeroCarteira: json['numeroCarteira'] as String,
      imagemPerfil: json['imagemPerfil'] as String?,
      documentoAssinado: json['documentoAssinado'] as String?,
      comprovanteResidencia: json['comprovanteResidencia'] as String?,
            senha: json['senha'] as String?,
    );
  }

  
  Usuario copyWith({
    String? cpf,
    String? nome,
    String? dataNascimento,
    String? cep,
    String? endereco,
    String? numeroEndereco,
    String? complementoEndereco,
    String? telefone,
    String? email,
    String? planoSaude,
    String? numeroCarteira,
    String? imagemPerfil,
    String? documentoAssinado,
    String? comprovanteResidencia,
  }) {
    return Usuario(
      cpf: cpf ?? this.cpf,
      nome: nome ?? this.nome,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      cep: cep ?? this.cep,
      endereco: endereco ?? this.endereco,
      numeroEndereco: numeroEndereco ?? this.numeroEndereco,
      complementoEndereco: complementoEndereco ?? this.complementoEndereco,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      planoSaude: planoSaude ?? this.planoSaude,
      numeroCarteira: numeroCarteira ?? this.numeroCarteira,
      imagemPerfil: imagemPerfil ?? this.imagemPerfil,
      documentoAssinado: documentoAssinado ?? this.documentoAssinado,
      comprovanteResidencia: comprovanteResidencia ?? this.comprovanteResidencia,
    );
  }
}
