import 'package:flutter/material.dart';
import '../../controller/shopping_controller.dart';
import '../../models/shopping_item.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final ShoppingController _controller = ShoppingController();
  final TextEditingController _textController = TextEditingController();

  void _addItem() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _controller.addItem(
        ShoppingItem(
          id: DateTime.now().toString(),
          name: text,     
        ),
      );
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        foregroundColor: const Color.fromARGB(255, 54, 97, 30),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar item',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Color.fromARGB(255, 54, 97, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: _controller.items.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum item na lista.',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                : ListView.separated(
                    itemCount: _controller.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _controller.items[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red[400],
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          setState(() {
                            _controller.removeItem(index);
                          });
                        },
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isBought,
                            onChanged: (value) {
                              setState(() {
                                _controller.toggleItem(index);
                              });
                            },
                            activeColor: Colors.green[200],
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 18,
                              decoration: item.isBought
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: item.isBought ? Colors.grey : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _controller.removeItem(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}