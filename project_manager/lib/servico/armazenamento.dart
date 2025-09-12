import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:teste_flutter/modelo/pessoa.dart';

class ArmazenamentoJson {
  Future<String> get _caminhoLocal async {
    final diretorio = await getApplicationDocumentsDirectory();
    return diretorio.path;
  }

  Future<File> get _arquivoLocal async {
    final caminho = await _caminhoLocal;
    return File('$caminho/dados.json');
  }

  Future<List<Pessoa>> lerDados() async {
    try {
      final arquivo = await _arquivoLocal;
      final conteudos = await arquivo.readAsString();
      List<dynamic> listaJson = jsonDecode(conteudos);
      return listaJson.map((item) => Pessoa.deMapa(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<File> escreverDados(List<Pessoa> pessoas) async {
    final arquivo = await _arquivoLocal;
    String stringJson = jsonEncode(
      pessoas.map((pessoa) => pessoa.paraMapa()).toList(),
    );
    return arquivo.writeAsString(stringJson);
  }
}
