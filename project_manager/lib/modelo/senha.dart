class Senha {
  int? id;
  String nome;
  String senha;

  Senha({
    this.id,
    required this.nome,
    required this.senha,
  });

  // Converter de Map para objeto Senha (do banco de dados)
  factory Senha.fromMap(Map<String, dynamic> map) {
    return Senha(
      id: map['id'],
      nome: map['nome'],
      senha: map['senha'],
    );
  }

  // Converter de objeto Senha para Map (para o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'senha': senha,
    };
  }

  @override
  String toString() {
    return 'Senha{id: $id, nome: $nome, senha: $senha}';
  }
}