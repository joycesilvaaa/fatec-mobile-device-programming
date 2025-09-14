import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(ProductApp());

class ProductApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Catálogo de Produtos', home: ProductList());
  }
}

class Product {
  int? id;
  String nome;
  double preco;
  String descricao;

  Product({this.id, required this.nome, required this.preco, required this.descricao});

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    nome: map['nome'],
    preco: map['preco'],
    descricao: map['descricao'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'preco': preco,
    'descricao': descricao,
  };
}

class ProductList extends StatefulWidget {
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];
  Database? db;

  Future<void> initDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'products.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, nome TEXT, preco REAL, descricao TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> fetchProductsFromApi() async {
    final res = await http.get(Uri.parse('http://localhost:3001/produtos'));
    final List data = json.decode(res.body);
    await db?.delete('products');
    for (var item in data) {
      await db?.insert('products', {
        'id': item['id'],
        'nome': item['nome'],
        'preco': item['preco'],
        'descricao': item['descricao'],
      });
    }
    loadProducts();
  }

  Future<void> loadProducts() async {
    final List<Map<String, dynamic>> maps = await db!.query('products');
    setState(() {
      products = List.generate(maps.length, (i) => Product.fromMap(maps[i]));
    });
  }

  Future<void> updateProduct(Product product) async {
    await db?.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
    loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await db?.delete('products', where: 'id = ?', whereArgs: [id]);
    loadProducts();
  }

  @override
  void initState() {
    super.initState();
    initDb().then((_) {
      fetchProductsFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return ListTile(
            title: Text(p.nome),
            subtitle: Text('${p.descricao}\nR\$ ${p.preco.toStringAsFixed(2)}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // Exemplo de edição simples
                    final nomeController = TextEditingController(text: p.nome);
                    final precoController = TextEditingController(text: p.preco.toString());
                    final descricaoController = TextEditingController(text: p.descricao);
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Editar Produto'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
                            TextField(controller: precoController, decoration: InputDecoration(labelText: 'Preço'), keyboardType: TextInputType.number),
                            TextField(controller: descricaoController, decoration: InputDecoration(labelText: 'Descrição')),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Salvar'),
                            onPressed: () {
                              updateProduct(Product(
                                id: p.id,
                                nome: nomeController.text,
                                preco: double.tryParse(precoController.text) ?? p.preco,
                                descricao: descricaoController.text,
                              ));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteProduct(p.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}