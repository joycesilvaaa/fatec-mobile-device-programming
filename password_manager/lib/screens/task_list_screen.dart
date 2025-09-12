import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../services/database_helper.dart';
import 'adicionar_tarefa_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Tarefa> _tarefas = [];
  List<Tarefa> _tarefasFiltradas = [];
  PrioridadeNivel? _filtroAtivo;
  Map<PrioridadeNivel, int> _contadores = {};

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
    _carregarContadores();
  }

  Future<void> _carregarTarefas() async {
    List<Tarefa> tarefas;
    if (_filtroAtivo != null) {
      tarefas = await _databaseHelper.buscarTarefasPorPrioridade(_filtroAtivo!);
    } else {
      tarefas = await _databaseHelper.buscarTodasTarefas();
    }
    
    setState(() {
      _tarefas = tarefas;
      _tarefasFiltradas = tarefas;
    });
  }

  Future<void> _carregarContadores() async {
    final contadores = await _databaseHelper.contarTarefasPorPrioridade();
    setState(() {
      _contadores = contadores;
    });
  }

  Future<void> _deletarTarefa(int id) async {
    await _databaseHelper.deletarTarefa(id);
    _carregarTarefas();
    _carregarContadores();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa deletada com sucesso!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filtrarPorPrioridade(PrioridadeNivel? prioridade) {
    setState(() {
      _filtroAtivo = prioridade;
    });
    _carregarTarefas();
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

  void _mostrarDialogoConfirmacao(int id, String nome) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja deletar a tarefa "$nome"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletarTarefa(id);
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

  Widget _buildFiltroChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: Text('Todas (${_tarefas.length})'),
            selected: _filtroAtivo == null,
            onSelected: (selected) {
              if (selected) _filtrarPorPrioridade(null);
            },
          ),
          const SizedBox(width: 8),
          ...PrioridadeNivel.values.map((prioridade) {
            final count = _contadores[prioridade] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text('${prioridade.displayName} ($count)'),
                selected: _filtroAtivo == prioridade,
                selectedColor: _getCorPrioridade(prioridade).withOpacity(0.3),
                onSelected: (selected) {
                  if (selected) {
                    _filtrarPorPrioridade(prioridade);
                  } else {
                    _filtrarPorPrioridade(null);
                  }
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Prioridades'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildFiltroChips(),
          const SizedBox(height: 16),
          Expanded(
            child: _tarefasFiltradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _filtroAtivo == null 
                              ? 'Nenhuma tarefa cadastrada'
                              : 'Nenhuma tarefa ${_filtroAtivo!.displayName.toLowerCase()}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Toque no botão + para adicionar uma tarefa',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _tarefasFiltradas.length,
                    itemBuilder: (context, index) {
                      final tarefa = _tarefasFiltradas[index];
                      final cor = _getCorPrioridade(tarefa.prioridade);
                      final icone = _getIconePrioridade(tarefa.prioridade);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              icone,
                              color: cor,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            tarefa.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Prioridade: ${tarefa.prioridade.displayName}',
                            style: TextStyle(
                              color: cor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () async {
                                  final resultado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdicionarTarefaScreen(
                                        tarefa: tarefa,
                                      ),
                                    ),
                                  );
                                  if (resultado == true) {
                                    _carregarTarefas();
                                    _carregarContadores();
                                  }
                                },
                                tooltip: 'Editar tarefa',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => _mostrarDialogoConfirmacao(
                                  tarefa.id!,
                                  tarefa.nome,
                                ),
                                tooltip: 'Deletar tarefa',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdicionarTarefaScreen(),
            ),
          );
          if (resultado == true) {
            _carregarTarefas();
            _carregarContadores();
          }
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}