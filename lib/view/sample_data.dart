import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

List<CalendarEvent> sampleEvents() {
  final today = DateTime.now();
  final sampleEvents = [
    /* CalendarEvent(
      eventName: "Present",
      eventDate: DateTime(2021, 10, 22),
      eventBackgroundColor: Colors.green,
    ), */
    CalendarEvent(
      eventName: "Holiday",
      eventDate: DateTime(2021, 10, 21),
      eventBackgroundColor: Colors.orange,
    ),
    CalendarEvent(
      eventName: "Absent",
      eventDate: DateTime(2021, 10, 17),
      eventBackgroundColor: Colors.red,
    ),
    CalendarEvent(
      eventName: "Absent",
      eventDate: DateTime(2021, 10, 10),
      eventBackgroundColor: Colors.red,
    ),
    CalendarEvent(
      eventName: "Present",
      eventDate: DateTime(2021, 10, 22),
      eventBackgroundColor: Colors.green,
    ),
    CalendarEvent(
        eventName: "Gym",
        eventDate: today.add(const Duration(days: 42)),
        eventBackgroundColor: Colors.indigoAccent),
  ];
  return sampleEvents;
}
