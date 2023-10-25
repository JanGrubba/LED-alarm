import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:led_alarm/controller/locator.dart';
import 'package:led_alarm/model/event.dart';
import 'package:led_alarm/service/event_service.dart';
import 'package:meta/meta.dart';
import 'dart:async';

part 'events_list_event.dart';

part 'events_list_state.dart';

class EventsListBloc extends Bloc<EventsListEvent, EventsListState> with ChangeNotifier {
  final EventService eventService = locator.get<EventService>();

  EventsListBloc() : super(EventsListState());

  @override
  Stream<EventsListState> mapEventToState(EventsListEvent event) async* {
    if (event.runtimeType == GetEventsListEvent) {
      List<Event> events = await _fetchEventsList();
      yield EventsListState(events: events);
    } else if (event.runtimeType == AddNewEventEvent) {
      List<Event> events = await _addEvent(event as AddNewEventEvent);
      yield EventsListState(events: events);
    } else if (event.runtimeType == EditEventEvent) {
      List<Event> events = await _editEvent(event as EditEventEvent);
      yield EventsListState(events: events);
    } else if (event.runtimeType == AddToDeletionEventsListEvent) {
      List<Event> newList = await _addEventToDeletionList(event as AddToDeletionEventsListEvent);
      yield state.copyWith(eventsToDelete: newList);
    } else if (event.runtimeType == DeleteEventsListEvent) {
      await _deleteEvents(event as DeleteEventsListEvent);
      List<Event> events = await _updateEventsList();
      yield EventsListState(events: events);
    }
  }

  Future<List<Event>> _fetchEventsList() async {
    return (state.events == null) ? await _updateEventsList() : state.events!;
  }

  Future<List<Event>> _updateEventsList() async {
    return await eventService.getEvents();
  }

  Future<List<Event>> _addEvent(AddNewEventEvent event) {
    return eventService.addEvent(event.event);
  }

  Future<List<Event>> _editEvent(EditEventEvent event) async {
    return await eventService.editEvent(event.event);
  }

  Future<List<Event>> _addEventToDeletionList(AddToDeletionEventsListEvent event) async {
    Event eventToDelete = event.event;
    List<Event> list = state.eventsToDelete ?? <Event>[];
    list.contains(eventToDelete) ? list.remove(eventToDelete) : list.add(eventToDelete);
    return List<Event>.from(list);
  }

  Future<void> _deleteEvents(DeleteEventsListEvent event) async {
    for (Event event in state.eventsToDelete ?? [])  {
      await eventService.deleteEvent(event);
    }
  }
}
