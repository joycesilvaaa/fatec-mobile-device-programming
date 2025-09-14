import 'package:daily_tasks/models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  List<Task> getTasks() {
    return _tasks;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
  }

  void toggleTaskCompletion(int index) {
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    }
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.title == task.title);
    if (index != -1) {
      _tasks[index] = task;
    }
  }
}
