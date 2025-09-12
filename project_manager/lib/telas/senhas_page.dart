import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modelo/senha.dart';
import '../servico/database_helper.dart';

class SenhasPage extends StatefulWidget {
  const SenhasPage({super.key});

  @override
  State<SenhasPage> createState() => _SenhasPageState();
}

class _SenhasPageState extends State<SenhasPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Senha> _senhas = [];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarSenhas();
  }

  Future<void> _carregarSenhas() async {
    final senhas = await _databaseHelper.buscarTodasSenhas();
    setState(() {
      _senhas = senhas;
    });
  }

  Future<void> _adicionarSenha() async {
    if (_nomeController.text.isNotEmpty && _senhaController.text.isNotEmpty) {
      final novaSenha = Senha(
        nome: _nomeController.text,
        senha: _senhaController.text,
      );

      await _databaseHelper.inserirSenha(novaSenha);
      _nomeController.clear();
      _senhaController.clear();
      _carregarSenhas();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha adicionada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _deletarSenha(int id) async {
    await _databaseHelper.deletarSenha(id);
    _carregarSenhas();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha deletada com sucesso!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _mostrarDialogoAdicionar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Nova Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome/Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nomeController.clear();
                _senhaController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _adicionarSenha,
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _copiarSenha(String senha) {
    Clipboard.setData(ClipboardData(text: senha));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Senha copiada para a área de transferência!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _mostrarDialogoConfirmacao(int id, String nome) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja deletar a senha "$nome"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletarSenha(id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Senhas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _senhas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma senha cadastrada',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque no botão + para adicionar uma senha',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _senhas.length,
              itemBuilder: (context, index) {
                final senha = _senhas[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.vpn_key,
                      color: Colors.blue,
                    ),
                    title: Text(
                      senha.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '•' * senha.senha.length,
                      style: const TextStyle(
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => _copiarSenha(senha.senha),
                          tooltip: 'Copiar senha',
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _mostrarDialogoConfirmacao(
                            senha.id!,
                            senha.nome,
                          ),
                          tooltip: 'Deletar senha',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionar,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}