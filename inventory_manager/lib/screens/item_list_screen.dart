import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/item.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    setState(() {
      _itemsFuture = DatabaseHelper().getItems();
    });
  }

  void _increment(Item item) async {
    item.quantidade++;
    await DatabaseHelper().updateItem(item);
    _refreshItems();
  }

  void _decrement(Item item) async {
    if (item.quantidade > 0) {
      item.quantidade--;
      await DatabaseHelper().updateItem(item);
      _refreshItems();
    }
  }

  void _addItemDialog() {
    final nomeController = TextEditingController();
    final quantidadeController = TextEditingController();
    final precoController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: quantidadeController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nome = nomeController.text;
              final quantidade = int.tryParse(quantidadeController.text) ?? 0;
              final preco = double.tryParse(precoController.text) ?? 0.0;
              if (nome.isNotEmpty) {
                await DatabaseHelper().insertItem(
                  Item(nome: nome, quantidade: quantidade, preco: preco),
                );
                _refreshItems();
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum item cadastrado.'));
          }
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.nome),
                subtitle: Text('Qtd: ${item.quantidade} | Preço: R\$${item.preco.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _decrement(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _increment(item),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItemDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
