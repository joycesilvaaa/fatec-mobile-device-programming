import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(ContactApp());

class ContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Gerenciador de Contatos', home: ContactList());
  }
}

class Contact {
  int? id;
  String nome;
  String telefone;
  String email;

  Contact({this.id, required this.nome, required this.telefone, required this.email});

  factory Contact.fromMap(Map<String, dynamic> map) => Contact(
    id: map['id'],
    nome: map['nome'],
    telefone: map['telefone'],
    email: map['email'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'telefone': telefone,
    'email': email,
  };
}

class ContactList extends StatefulWidget {
  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> contacts = [];
  Database? db;
  bool loading = false;
  String? error;

  Future<void> initDb() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'contacts.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE contacts(id INTEGER PRIMARY KEY, nome TEXT, telefone TEXT, email TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> syncContactsFromApi() async {
    setState(() { loading = true; error = null; });
    try {
      final res = await http.get(Uri.parse('http://localhost:3002/contatos'));
      if (res.statusCode != 200) throw Exception('Erro ao buscar contatos');
      final List data = json.decode(res.body);
      await db?.delete('contacts');
      for (var item in data) {
        await db?.insert('contacts', {
          'id': item['id'],
          'nome': item['nome'],
          'telefone': item['telefone'],
          'email': item['email'],
        });
      }
      await loadContacts();
    } catch (e) {
      setState(() { error = e.toString(); });
    }
    setState(() { loading = false; });
  }

  Future<void> loadContacts() async {
    final List<Map<String, dynamic>> maps = await db!.query('contacts');
    setState(() {
      contacts = List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
    });
  }

  Future<void> addContact(Contact contact) async {
    setState(() { loading = true; error = null; });
    try {
      final res = await http.post(
        Uri.parse('http://localhost:3002/contatos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(contact.toMap()),
      );
      if (res.statusCode != 201) throw Exception('Erro ao adicionar contato');
      final newContact = Contact.fromMap(json.decode(res.body));
      await db?.insert('contacts', newContact.toMap());
      await loadContacts();
    } catch (e) {
      setState(() { error = e.toString(); });
    }
    setState(() { loading = false; });
  }

  Future<void> updateContact(Contact contact) async {
    setState(() { loading = true; error = null; });
    try {
      final res = await http.put(
        Uri.parse('http://localhost:3002/contatos/${contact.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(contact.toMap()),
      );
      if (res.statusCode != 200) throw Exception('Erro ao atualizar contato');
      await db?.update('contacts', contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
      await loadContacts();
    } catch (e) {
      setState(() { error = e.toString(); });
    }
    setState(() { loading = false; });
  }

  Future<void> deleteContact(int id) async {
    setState(() { loading = true; error = null; });
    try {
      final res = await http.delete(Uri.parse('http://localhost:3002/contatos/$id'));
      if (res.statusCode != 204) throw Exception('Erro ao deletar contato');
      await db?.delete('contacts', where: 'id = ?', whereArgs: [id]);
      await loadContacts();
    } catch (e) {
      setState(() { error = e.toString(); });
    }
    setState(() { loading = false; });
  }

  @override
  void initState() {
    super.initState();
    initDb().then((_) {
      syncContactsFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contatos')),
      body: loading
        ? Center(child: CircularProgressIndicator())
        : error != null
          ? Center(child: Text('Erro: $error'))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, i) {
                final c = contacts[i];
                return ListTile(
                  title: Text(c.nome),
                  subtitle: Text('${c.telefone}\n${c.email}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final nomeController = TextEditingController(text: c.nome);
                          final telController = TextEditingController(text: c.telefone);
                          final emailController = TextEditingController(text: c.email);
                          await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Editar Contato'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
                                  TextField(controller: telController, decoration: InputDecoration(labelText: 'Telefone')),
                                  TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Salvar'),
                                  onPressed: () {
                                    updateContact(Contact(
                                      id: c.id,
                                      nome: nomeController.text,
                                      telefone: telController.text,
                                      email: emailController.text,
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
                        onPressed: () => deleteContact(c.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final nomeController = TextEditingController();
          final telController = TextEditingController();
          final emailController = TextEditingController();
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Novo Contato'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
                  TextField(controller: telController, decoration: InputDecoration(labelText: 'Telefone')),
                  TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Adicionar'),
                  onPressed: () {
                    addContact(Contact(
                      nome: nomeController.text,
                      telefone: telController.text,
                      email: emailController.text,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}