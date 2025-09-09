class EventRegistrationItem {
  static int _nextId = 1;
  final int id;
  String date;
  String time;
  String eventName;
  String eventDescription;

  EventRegistrationItem({
    required this.date,
    required this.time,
    required this.eventName,
    required this.eventDescription,
  }) : id = _nextId++;

  EventRegistrationItem._withExistingId({
    required this.id,
    required this.date,
    required this.time,
    required this.eventName,
    required this.eventDescription,
  });

  factory EventRegistrationItem.fromJson(Map<String, dynamic> json) {
    final int incomingId = json['id'];
    if (incomingId >= _nextId) {
      _nextId = incomingId + 1;
    }
    return EventRegistrationItem._withExistingId(
      id: incomingId,
      date: json['date'],
      time: json['time'],
      eventName: json['eventName'],
      eventDescription: json['eventDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'eventName': eventName,
      'eventDescription': eventDescription,
    };
  }
  EventRegistrationItem copyWith({
    int? id,
    String? date,
    String? time,
    String? eventName,
    String? eventDescription,
  }) {
    return EventRegistrationItem._withExistingId(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      eventName: eventName ?? this.eventName,
      eventDescription: eventDescription ?? this.eventDescription,
    );
  }
}