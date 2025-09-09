import 'package:event_registration_app/repositories/event_repository.dart';
import 'package:event_registration_app/models/event_item.dart';
class EventController {
  final EventRepository _eventRepository = EventRepository();

  Future<List<EventRegistrationItem>> fetchAllEvents() async {
    return await _eventRepository.getAllEvents();
  }

  Future<void> addEvent(EventRegistrationItem event) async {
    await _eventRepository.saveEvent(event);
  }

  Future<void> updateEvent(int id, String newName, String newDescription, String newDate, String newTime) async {
    await _eventRepository.updateEvent(id, newName, newDescription, newDate, newTime);
  }

  Future<void> removeEvent(int id) async {
    await _eventRepository.removeEvent(id);
  }

}