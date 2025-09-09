class ShoppingListItem {
  static int _nextId = 1;
  final int id;
  String itemName;
  bool isCompleted;

  ShoppingListItem({
    required this.itemName,
    this.isCompleted = false,
  }) : id = _nextId++;

  ShoppingListItem._withExistingId({
    required this.id,
    required this.itemName,
    required this.isCompleted,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    final int incomingId = json['id'];
    if (incomingId >= _nextId) {
      _nextId = incomingId + 1;
    }
    return ShoppingListItem._withExistingId(
      id: incomingId,
      itemName: json['itemName'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'isCompleted': isCompleted,
    };
  }
  ShoppingListItem copyWith({
    int? id,
    String? itemName,
    bool? isCompleted,
  }) {
    return ShoppingListItem._withExistingId(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}