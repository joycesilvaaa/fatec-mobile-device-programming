import 'package:daily_tasks/models/task.dart';
import 'package:daily_tasks/repositories/task_repository.dart';
import 'package:flutter/material.dart ';


class TaskController extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();

  List<Task> get tasks => _repository.getTasks();

  void addTask(String title, String description, Priority priority) {
    final newTask = Task(
      title: title,
      description: description,
      priority: priority,
    );
    _repository.addTask(newTask);
    notifyListeners();
  }

  void removeTask(int index) {
    _repository.removeTask(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    _repository.toggleTaskCompletion(index);
    notifyListeners();
  }
}
