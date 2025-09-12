import 'package:flutter/material.dart';
import 'package:teste_flutter/modelo/pessoa.dart';
import 'package:teste_flutter/servico/armazenamento.dart';

class ExemploScaffold extends StatefulWidget {
  const ExemploScaffold({super.key});

  @override
  _ExemploScaffoldState createState() => _ExemploScaffoldState();
}

class _ExemploScaffoldState extends State<ExemploScaffold> {
  int _indiceSelecionado = 0;
  final ArmazenamentoJson _armazenamentoJson = ArmazenamentoJson();
  List<Pessoa> _pessoas = [];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  Pessoa? _pessoaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async {
    List<Pessoa> pessoas = await _armazenamentoJson.lerDados();
    setState(() {
      _pessoas = pessoas;
    });
  }

  _adicionarPessoa() async {
    final nome = _nomeController.text;
    final idade = int.tryParse(_idadeController.text);

    if (nome.isNotEmpty && idade != null) {
      Pessoa novaPessoa = Pessoa(nome: nome, idade: idade);
      _pessoas.add(novaPessoa);
      await _armazenamentoJson.escreverDados(_pessoas);
      _carregarDados();
      _limparFormulario();
    }
  }

  _atualizarPessoa() async {
    if (_pessoaSelecionada != null) {
      final nome = _nomeController.text;
      final idade = int.tryParse(_idadeController.text);

      if (nome.isNotEmpty && idade != null) {
        _pessoaSelecionada!.nome = nome;
        _pessoaSelecionada!.idade = idade;
        await _armazenamentoJson.escreverDados(_pessoas);
        _carregarDados();
        _limparFormulario();
      }
    }
  }

  _excluirPessoa(Pessoa pessoa) async {
    _pessoas.remove(pessoa);
    await _armazenamentoJson.escreverDados(_pessoas);
    _carregarDados();
  }

  _limparFormulario() {
    _nomeController.clear();
    _idadeController.clear();
    _pessoaSelecionada = null;
  }

  void _aoTocarItem(int indice) {
    setState(() {
      _indiceSelecionado = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD com JSON'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
          ),
        ],
      ),
      body: _indiceSelecionado == 0
          ? _construirFormulario()
          : _indiceSelecionado == 1
          ? _construirListaPessoas()
          : _indiceSelecionado == 2
          ? _construirFormularioAtualizacao()
          : _construirFormularioExclusao(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Cadastrar'),
              onTap: () => _aoTocarItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Consultar'),
              onTap: () => _aoTocarItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Alterar'),
              onTap: () => _aoTocarItem(2),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Excluir'),
              onTap: () => _aoTocarItem(3),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelecionado,
        onTap: _aoTocarItem,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Cadastrar'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Consultar'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Alterar'),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: 'Excluir'),
        ],
      ),
    );
  }

  Widget _construirFormulario() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: _idadeController,
            decoration: const InputDecoration(labelText: 'Idade'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _adicionarPessoa,
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  Widget _construirListaPessoas() {
    return ListView.builder(
      itemCount: _pessoas.length,
      itemBuilder: (context, indice) {
        final pessoa = _pessoas[indice];
        return ListTile(
          title: Text(pessoa.nome),
          subtitle: Text('Idade: ${pessoa.idade}'),
        );
      },
    );
  }

  Widget _construirFormularioAtualizacao() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nomeController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: _idadeController,
            decoration: const InputDecoration(labelText: 'Idade'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _atualizarPessoa,
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }

  Widget _construirFormularioExclusao() {
    return ListView.builder(
      itemCount: _pessoas.length,
      itemBuilder: (context, indice) {
        final pessoa = _pessoas[indice];
        return ListTile(
          title: Text(pessoa.nome),
          subtitle: Text('Idade: ${pessoa.idade}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _excluirPessoa(pessoa),
          ),
        );
      },
    );
  }
}
