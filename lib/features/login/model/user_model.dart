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
        String? senha,
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
        senha: senha ?? this.senha,
    );
  }
}


class OperadoraPlanoSaude {
  final String id;
  final String nomeSocial;
  final String cnpj;
  final String registroANS;
  final ParametrosAutorizacao parametrosAutorizacao;

  OperadoraPlanoSaude({
    required this.id,
    required this.nomeSocial,
    required this.cnpj,
    required this.registroANS,
    required this.parametrosAutorizacao,
  });

  factory OperadoraPlanoSaude.fromJson(Map<String, dynamic> json) {
    return OperadoraPlanoSaude(
      id: json['id'],
      nomeSocial: json['nomeSocial'],
      cnpj: json['cnpj'],
      registroANS: json['registroANS'],
      parametrosAutorizacao: ParametrosAutorizacao.fromJson(json['parametrosAutorizacao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeSocial': nomeSocial,
      'cnpj': cnpj,
      'registroANS': registroANS,
      'parametrosAutorizacao': parametrosAutorizacao.toJson(),
    };
  }
}

class ParametrosAutorizacao {
  final bool autorizacaoPreviaNecessaria;
  final int limiteConsultasAnual;

  ParametrosAutorizacao({
    required this.autorizacaoPreviaNecessaria,
    required this.limiteConsultasAnual,
  });

  factory ParametrosAutorizacao.fromJson(Map<String, dynamic> json) {
    return ParametrosAutorizacao(
      autorizacaoPreviaNecessaria: json['autorizacaoPreviaNecessaria'],
      limiteConsultasAnual: json['limiteConsultasAnual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autorizacaoPreviaNecessaria': autorizacaoPreviaNecessaria,
      'limiteConsultasAnual': limiteConsultasAnual,
    };
  }
}

class PlanoSaude {
  final List<OperadoraPlanoSaude> operadorasPlanoSaude;

  PlanoSaude({required this.operadorasPlanoSaude});

  factory PlanoSaude.fromJson(Map<String, dynamic> json) {
    var list = json['operadorasPlanoSaude'] as List;
    List<OperadoraPlanoSaude> operadoras = list.map((i) => OperadoraPlanoSaude.fromJson(i)).toList();

    return PlanoSaude(operadorasPlanoSaude: operadoras);
  }

  Map<String, dynamic> toJson() {
    return {
      'operadorasPlanoSaude': operadorasPlanoSaude.map((e) => e.toJson()).toList(),
    };
  }
}




class RetornoGuiaModel {
  final int? idGuia;
  final int? numeroGuia;
  final int? codigoGuiaANS;
  final DateTime? dataAutorizacao;
  final DateTime? dataValidade;
  final String? status;

  RetornoGuiaModel({
    this.idGuia,
    this.numeroGuia,
    this.codigoGuiaANS,
    this.dataAutorizacao,
    this.dataValidade,
    this.status,
  });

  // Construtor para criar uma instância a partir de um Map (JSON)
  factory RetornoGuiaModel.fromJson(Map<String, dynamic> json) {
    return RetornoGuiaModel(
      idGuia: json['idGuia'] as int?,
      numeroGuia: json['numeroGuia'] as int?,
      codigoGuiaANS: json['codigoGuiaANS'] as int?,
      dataAutorizacao: json['dataAutorizacao'] != null
          ? DateTime.parse(json['dataAutorizacao'])
          : null,
      dataValidade: json['dataValidade'] != null
          ? DateTime.parse(json['dataValidade'])
          : null,
      status: json['status'] as String?,
    );
  }

  // Método para converter a instância em Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'idGuia': idGuia,
      'numeroGuia': numeroGuia,
      'codigoGuiaANS': codigoGuiaANS,
      'dataAutorizacao': dataAutorizacao?.toIso8601String(),
      'dataValidade': dataValidade?.toIso8601String(),
      'status': status,
    };
  }
}
