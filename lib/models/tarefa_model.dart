class Tarefa {
  final int id;
  final String titulo;
  final String descricao;
  final DateTime dataCriacao;
  final int status;
  final String? imagem;

  Tarefa({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataCriacao,
    required this.status,
    this.imagem,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id_tarefa'],
      titulo: json['nm_tarefa'],
      descricao: json['txt_descricao'],
      dataCriacao: DateTime.parse(json['dt_criacao']),
      status: json['status_tarefa'] as int,
      imagem: json['img_tarefa']?.toString(),
    );
  }
}
