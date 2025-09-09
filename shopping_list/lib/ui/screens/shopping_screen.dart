import 'package:flutter/material.dart';
import '../../controller/shopping_controller.dart';
import '../../models/shopping_item.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final ShoppingController _controller = ShoppingController();
  late Future<List<ShoppingListItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _refreshItemList();
  }

  void _refreshItemList() {
    setState(() {
      _itemsFuture = _controller.fetchAllItems();
    });
  }


  void _toggleItemCompleted(ShoppingListItem item) {
    _controller
        .updateItem(item.id, item.itemName, !item.isCompleted)
        .then((_) => _refreshItemList());
  }

  void _showAddItemDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Item',
                icon: Icon(Icons.shopping_basket),
              ),
              validator: (value) =>
                  (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
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
                  final newItem = ShoppingListItem(
                    itemName: nameController.text,
                  );
                  _controller.addItem(newItem).then((_) => _refreshItemList());
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
        content: const Text('Você tem certeza que deseja excluir este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              _controller.removeItem(id).then((_) => _refreshItemList());
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
        title: const Text('Lista de Compras'),
      ),
      body: FutureBuilder<List<ShoppingListItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar itens: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum item na lista.\nClique no botão "+" para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final items = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                color: item.isCompleted ? Colors.grey.shade200 : null,
                child: ListTile(
                  leading: Checkbox(
                    value: item.isCompleted,
                    onChanged: (bool? value) {
                      _toggleItemCompleted(item);
                    },
                  ),
                  title: Text(
                    item.itemName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: item.isCompleted ? Colors.grey : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _showDeleteConfirmation(item.id),
                    tooltip: 'Excluir',
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        tooltip: 'Adicionar Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}