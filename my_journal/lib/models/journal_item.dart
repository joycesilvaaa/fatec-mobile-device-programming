class JournalItem {
  static int _nextId = 1;
  final int id;
  String itemName;
  String itemDescription;
  final DateTime createAt;

  JournalItem({
    required this.itemName,
    required this.itemDescription,
  }) : id = _nextId++,
      createAt = DateTime.now();

  JournalItem._withExistingId({
    required this.id,
    required this.createAt,
    required this.itemName,
    required this.itemDescription,
  });

  factory JournalItem.fromJson(Map<String, dynamic> json) {
    final int incomingId = json['id'];
    if (incomingId >= _nextId) {
      _nextId = incomingId + 1;
    }
    return JournalItem._withExistingId(
      id: incomingId,
      createAt: DateTime.parse(json['createAt']),
      itemName: json['itemName'],
      itemDescription: json['itemDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createAt': createAt.toIso8601String(),
      'itemName': itemName,
      'itemDescription': itemDescription,
    };
  }
  JournalItem copyWith({
    int? id,
    DateTime? createAt,
    String? itemName,
    String? itemDescription,
  }) {
    return JournalItem._withExistingId(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      itemName: itemName ?? this.itemName,
      itemDescription: itemDescription ?? this.itemDescription,
    );
  }
}