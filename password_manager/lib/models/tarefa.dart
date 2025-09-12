enum PrioridadeNivel {
  alta('Alta'),
  media('Média'),
  baixa('Baixa');

  const PrioridadeNivel(this.displayName);
  final String displayName;
}

class Tarefa {
  int? id;
  String nome;
  PrioridadeNivel prioridade;

  Tarefa({
    this.id,
    required this.nome,
    required this.prioridade,
  });

  // Converter de Map para objeto Tarefa (do banco de dados)
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      nome: map['nome'],
      prioridade: PrioridadeNivel.values.firstWhere(
        (p) => p.displayName == map['prioridade'],
      ),
    );
  }

  // Converter de objeto Tarefa para Map (para o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'prioridade': prioridade.displayName,
    };
  }

  @override
  String toString() {
    return 'Tarefa{id: $id, nome: $nome, prioridade: ${prioridade.displayName}}';
  }
}