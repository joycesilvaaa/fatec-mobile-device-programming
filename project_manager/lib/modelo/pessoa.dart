class Pessoa {
  String nome;
  int idade;

  Pessoa({required this.nome, required this.idade});

  Map<String, dynamic> paraMapa() {
    return {'nome': nome, 'idade': idade};
  }

  static Pessoa deMapa(Map<String, dynamic> mapa) {
    return Pessoa(nome: mapa['nome'], idade: mapa['idade']);
  }
}
