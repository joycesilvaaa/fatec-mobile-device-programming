import 'package:daily_tasks/controllers/task_controller.dart';
import 'package:daily_tasks/models/task.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController _controller = TaskController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _selectedPriority = Priority.low;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas Diarias'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 7, 85, 148),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _controller.tasks.length,
              itemBuilder: (context, index) {
                final task = _controller.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _controller.toggleTaskCompletion(index);
                      });
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(switch (task.priority) {
                        Priority.high => 'Alta',
                        Priority.medium => 'Média',
                        Priority.low => 'Baixa',
                      }),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 7, 85, 148),
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.removeTask(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    const SizedBox(height: 16),
                    const Text('Prioridade'),
                    Row(
                      children: [
                        Radio<Priority>(
                          value: Priority.low,
                          groupValue: _selectedPriority,
                          onChanged: (Priority? value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                        ),
                        const Text('Baixa'),
                        Radio<Priority>(
                          value: Priority.medium,
                          groupValue: _selectedPriority,
                          onChanged: (Priority? value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                        ),
                        const Text('Média'),
                        Radio<Priority>(
                          value: Priority.high,
                          groupValue: _selectedPriority,
                          onChanged: (Priority? value) {
                            setState(() {
                              _selectedPriority = value!;
                            });
                          },
                        ),
                        const Text('Alta'),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _controller.addTask(
                    _titleController.text,
                    _descriptionController.text,
                    _selectedPriority,
                  );
                  _titleController.clear();
                  _descriptionController.clear();
                  _selectedPriority = Priority.low;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
