class Especialidade {
  final int id;
  final String nomeEspecialidade;
  final String descricao;
  final bool necessitaEncaminhamento;

  Especialidade({
    required this.id,
    required this.nomeEspecialidade,
    required this.descricao,
    required this.necessitaEncaminhamento,
  });

  factory Especialidade.fromJson(Map<String, dynamic> json) {
    return Especialidade(
      id: json['id'],
      nomeEspecialidade: json['nome'],
      descricao: json['descricao'],
      necessitaEncaminhamento: json['necessitaEncaminhamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeEspecialidade': nomeEspecialidade,
      'descricao': descricao,
      'necessitaEncaminhamento': necessitaEncaminhamento,
    };
  }
}
