import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/journal_controller.dart';
import '../../models/journal_item.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalController _controller = JournalController();
  final TextEditingController _searchController = TextEditingController();
  List<JournalItem> _allJournals = [];
  List<JournalItem> _filteredJournals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshJournalList();
    _searchController.addListener(_filterJournals);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshJournalList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final journals = await _controller.fetchAllJournals();
      setState(() {
        _allJournals = journals;
        _filteredJournals = journals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterJournals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredJournals = _allJournals.where((journal) {
        return journal.itemName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showJournalDialog({JournalItem? journal}) {
    final formKey = GlobalKey<FormState>();
    final isEditing = journal != null;

    final titleController = TextEditingController(text: journal?.itemName ?? '');
    final contentController = TextEditingController(text: journal?.itemDescription ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Entrada' : 'Nova Entrada'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      icon: Icon(Icons.title),
                    ),
                    validator: (value) =>
                        (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      labelText: 'Conteúdo',
                      icon: Icon(Icons.article),
                    ),
                    maxLines: 5,
                    validator: (value) =>
                        (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (isEditing) {
                    final updatedJournal = journal.copyWith(
                     itemName: titleController.text,
                     itemDescription: contentController.text,
                    );
                    _controller
                        .updateJournal(updatedJournal.id, updatedJournal.itemName, updatedJournal.itemDescription)
                        .then((_) => _refreshJournalList());
                  } else {
                    final newJournal = JournalItem(
                      itemName: titleController.text,
                      itemDescription: contentController.text,
                    );
                    _controller
                        .addJournal(newJournal)
                        .then((_) => _refreshJournalList());
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja excluir esta entrada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              _controller
                  .removeJournal(id)
                  .then((_) => _refreshJournalList());
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Diário'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredJournals.isEmpty
              ? Center(
                  child: Text(
                    _searchController.text.isEmpty
                        ? 'Nenhuma entrada no diário.\nClique no botão "+" para adicionar.'
                        : 'Nenhuma entrada encontrada.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _filteredJournals.length,
                  itemBuilder: (context, index) {
                    final journal = _filteredJournals[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            journal.itemName.isNotEmpty ? journal.itemName[0].toUpperCase() : '?',
                            style: TextStyle(color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                        title: Text(journal.itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '${DateFormat('dd/MM/yyyy HH:mm').format(journal.createAt)}\n${journal.itemDescription}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _showJournalDialog(journal: journal),
                              tooltip: 'Editar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _showDeleteConfirmation(journal.id),
                              tooltip: 'Excluir',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJournalDialog(),
        tooltip: 'Adicionar Entrada',
        child: const Icon(Icons.add),
      ),
    );
  } 
}