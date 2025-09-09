import 'package:event_registration_app/models/event_item.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:event_registration_app/utils/log.dart';

class EventRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/events.json');
  }

  Future<List<EventRegistrationItem>> getAllEvents() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      if (! await file.exists() || contents.isEmpty) {
        return [];
      }
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData
          .map((item) => EventRegistrationItem.fromJson(item))
          .toList();
    } catch (e, s) {
      Log.e("Erro ao ler o arquivo", error: e, stackTrace: s);
      return [];
    }
  }

  Future<void> saveEvent(EventRegistrationItem event) async {
    try {
      final events = await getAllEvents();
      events.add(event);
      final file = await _localFile;
      final jsonData = events.map((e) => e.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e, s) {
      Log.e("Erro ao salvar o evento", error: e, stackTrace: s);
    }
  }

  Future<void> updateEvent(int id, String newName, String newDescription, String newDate, String newTime) async {
    try {
      final events = await getAllEvents();
      final index = events.indexWhere((e) => e.id == id);
      if (index != -1) {
        events[index] = events[index].copyWith(
          eventName: newName,
          eventDescription: newDescription,
          date: newDate,
          time: newTime,
        );
        final file = await _localFile;
        final jsonData = events.map((e) => e.toJson()).toList();
        await file.writeAsString(json.encode(jsonData));
      }
    } catch (e, s) {
      Log.e("Erro ao atualizar o evento", error: e, stackTrace: s);
    }
  }

  Future<void> removeEvent(int id) async {
    try {
      final events = await getAllEvents();
      events.removeWhere((event) => event.id == id);
      final file = await _localFile;
      final jsonData = events.map((e) => e.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e, s) {
      Log.e("Erro ao remover o evento", error: e, stackTrace: s);
    }
  }


}
