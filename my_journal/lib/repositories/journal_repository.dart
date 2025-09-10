import 'package:my_journal/models/journal_item.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:my_journal/utils/log.dart';

class JournalRepository {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/journal.json');
  }

  Future<List<JournalItem>> getAllJournals() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      if (! await file.exists() || contents.isEmpty) {
        return [];
      }
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData
          .map((item) => JournalItem.fromJson(item))
          .toList();
    } catch (e, s) {
      Log.e("Erro ao ler o arquivo", error: e, stackTrace: s);
      return [];
    }
  }

  Future<void> saveJournal(JournalItem journal) async {
    try {
      final journals = await getAllJournals();
      journals.add(journal);
      final file = await _localFile;
      final jsonData = journals.map((e) => e.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e, s) {
      Log.e("Erro ao salvar o diário", error: e, stackTrace: s);
    }
  }

  Future<void> updateJournal(int id, String newName, String newDescription) async {
    try {
      final journals = await getAllJournals();
      final index = journals.indexWhere((e) => e.id == id);
      if (index != -1) {
        journals[index] = journals[index].copyWith(
          itemName: newName,
          itemDescription: newDescription,
        );
        final file = await _localFile;
        final jsonData = journals.map((e) => e.toJson()).toList();
        await file.writeAsString(json.encode(jsonData));
      }
    } catch (e, s) {
      Log.e("Erro ao atualizar o diário", error: e, stackTrace: s);
    }
  }

  Future<void> removeJournal(int id) async {
    try {
      final journals = await getAllJournals();
      journals.removeWhere((journal) => journal.id == id);
      final file = await _localFile;
      final jsonData = journals.map((e) => e.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
    } catch (e, s) {
      Log.e("Erro ao remover o diário", error: e, stackTrace: s);
    }
  }


}
