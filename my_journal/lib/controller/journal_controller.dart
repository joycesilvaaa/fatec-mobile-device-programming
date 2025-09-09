import 'package:my_journal/repositories/journal_repository.dart';
import 'package:my_journal/models/journal_item.dart';

class JournalController {
  final JournalRepository _journalRepository = JournalRepository();

  Future<List<JournalItem>> fetchAllJournals() async {
    return await _journalRepository.getAllJournals();
  }

  Future<void> addJournal(JournalItem journal) async {
    await _journalRepository.saveJournal(journal);
  }

  Future<void> updateJournal(int id, String newName, String newDescription) async {
    await _journalRepository.updateJournal(id, newName, newDescription);
  }

  Future<void> removeJournal(int id) async {
    await _journalRepository.removeJournal(id);
  }

}