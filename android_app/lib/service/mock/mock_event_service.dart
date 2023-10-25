import 'package:faker/faker.dart';
import 'package:led_alarm/model/event.dart';
import 'package:led_alarm/service/event_service.dart';

class LocalEventService extends EventService {
  final List<Event> events = List.generate(faker.randomGenerator.integer(5) + 2, (index) => Event.random());

  Future<List<Event>> getEvents() async {
    return List.from(events)..sort(compareEvents);
  }

  @override
  Future<List<Event>> addEvent(Event event) async {
    events.add(event);
    return events..sort(compareEvents);
  }

  @override
  Future<List<Event>> editEvent(Event event) async {
    int index = events.indexWhere((element) => element.id == event.id);
    if (events.isNotEmpty) events.removeWhere((element) => element.id == event.id);
    events.insert(index, event);
    return List.from(events..sort(compareEvents));
  }

  @override
  Future<void> deleteEvent(Event event) async {
    events.remove(event).toString();
  }

  @override
  void deleteSingleEvent(String uid, Event alarm) {
    // przy obecnie stosowanych rozwiązaniach nie powinno potrzebować implementacji
  }

  @override
  Future<List<Event>?> getAllEventsFromUser(String uid) {
    return Future.value(events);
  }

  @override
  void updateSingleEvent(String uid, Event alarm) {
    // przy obecnie stosowanych rozwiązaniach nie powinno potrzebować implementacji
  }

  @override
  void uploadEventToSpecificUsersData(String uid, Event alarm) {
    // przy obecnie stosowanych rozwiązaniach nie powinno potrzebować implementacji
  }

  @override
  void setEventsModificationDate() {
    // TODO: implement setEventsModificationDate
  }
}
