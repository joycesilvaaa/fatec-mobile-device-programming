import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(TaskApp());

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Gerenciador de Tarefas', home: TaskList());
  }
}

class TaskList extends StatefulWidget {
  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List tasks = [];
  final apiUrl = 'http://localhost:3000/tarefas';

  Future<void> fetchTasks() async {
    final res = await http.get(Uri.parse(apiUrl));
    setState(() => tasks = json.decode(res.body));
  }

  Future<void> addTask(String title) async {
    await http.post(Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'titulo': title}));
    fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('$apiUrl/$id'));
    fetchTasks();
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text('Tarefas')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: tasks.map<Widget>((task) => ListTile(
                title: Text(task['titulo']),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteTask(task['id']),
                ),
              )).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller)),
                ElevatedButton(
                  child: Text('Adicionar'),
                  onPressed: () {
                    addTask(controller.text);
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}