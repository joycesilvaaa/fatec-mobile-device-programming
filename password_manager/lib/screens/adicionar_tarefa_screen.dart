import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/database_helper.dart';

class AdicionarTarefaScreen extends StatefulWidget {
  final Tarefa? tarefa;

  const AdicionarTarefaScreen({super.key, this.tarefa});

  @override
  State<AdicionarTarefaScreen> createState() => _AdicionarTarefaScreenState();
}

class _AdicionarTarefaScreenState extends State<AdicionarTarefaScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _nomeController = TextEditingController();
  PrioridadeNivel _prioridadeSelecionada = PrioridadeNivel.media;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdicao => widget.tarefa != null;

  @override
  void initState() {
    super.initState();
    if (_isEdicao) {
      _nomeController.text = widget.tarefa!.nome;
      _prioridadeSelecionada = widget.tarefa!.prioridade;
    }
  }

  Future<void> _salvarTarefa() async {
    if (_formKey.currentState!.validate()) {
      final tarefa = Tarefa(
        id: _isEdicao ? widget.tarefa!.id : null,
        nome: _nomeController.text.trim(),
        prioridade: _prioridadeSelecionada,
      );

      try {
        if (_isEdicao) {
          await _databaseHelper.atualizarTarefa(tarefa);
        } else {
          await _databaseHelper.inserirTarefa(tarefa);
        }

        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isEdicao 
                    ? 'Tarefa atualizada com sucesso!'
                    : 'Tarefa adicionada com sucesso!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar tarefa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Color _getCorPrioridade(PrioridadeNivel prioridade) {
    switch (prioridade) {
      case PrioridadeNivel.alta:
        return Colors.red;
      case PrioridadeNivel.media:
        return Colors.orange;
      case PrioridadeNivel.baixa:
        return Colors.green;
    }
  }

  IconData _getIconePrioridade(PrioridadeNivel prioridade) {
    switch (prioridade) {
      case PrioridadeNivel.alta:
        return Icons.priority_high;
      case PrioridadeNivel.media:
        return Icons.remove;
      case PrioridadeNivel.baixa:
        return Icons.keyboard_arrow_down;
    }
  }

  Widget _buildSeletorPrioridade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nível de Prioridade',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...PrioridadeNivel.values.map((prioridade) {
          final cor = _getCorPrioridade(prioridade);
          final icone = _getIconePrioridade(prioridade);
          final isSelected = _prioridadeSelecionada == prioridade;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? cor : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? cor.withOpacity(0.1) : Colors.transparent,
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icone,
                  color: cor,
                  size: 24,
                ),
              ),
              title: Text(
                prioridade.displayName,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? cor : Colors.black87,
                ),
              ),
              trailing: Radio<PrioridadeNivel>(
                value: prioridade,
                groupValue: _prioridadeSelecionada,
                activeColor: cor,
                onChanged: (PrioridadeNivel? value) {
                  setState(() {
                    _prioridadeSelecionada = value!;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  _prioridadeSelecionada = prioridade;
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdicao ? 'Editar Tarefa' : 'Nova Tarefa'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nome da Tarefa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          hintText: 'Digite o nome da tarefa...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.task),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, digite o nome da tarefa';
                          }
                          if (value.trim().length < 3) {
                            return 'O nome deve ter pelo menos 3 caracteres';
                          }
                          return null;
                        },
                        maxLength: 100,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSeletorPrioridade(),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvarTarefa,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isEdicao ? 'Atualizar' : 'Adicionar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}