enum Priority { low, medium, high }

class Task {
  String title;
  String description;
  bool isCompleted;
  Priority priority;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.priority = Priority.low,
  });
}
