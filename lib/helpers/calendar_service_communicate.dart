import 'package:googleapis/calendar/v3.dart';
import 'google_http_client.dart';
import '../objs/calendar.dart';
import '../objs/event.dart';

class CalendarServiceCommunicate {
  CalendarServiceCommunicate(GoogleHttpClient client) {
    calendarApi = CalendarApi(client);
  }

  CalendarApi calendarApi;

  Calendar currentCalendar;

  Future<CalendarList> _getCalendarList() async {
    final result = await calendarApi.calendarList.list();
    return result;
  }

  Future<dynamic> deleteOldCalendars() async {
    final calendarList = await _getCalendarList();
    final items = calendarList.items;

    for (final i in items) {
      if (i.summary == CalendarStudentSocial.summary) {
        final result = await calendarApi.calendars.delete(i.id);
        return result;
      }
    }
  }

  Future<Calendar> insertNewCalendars() async {
    final result = await calendarApi.calendars
        .insert(Calendar.fromJson(CalendarStudentSocial.toJson()));
    currentCalendar = result;
    return result;
  }

  Stream<double> addEvents(List<EventStudentSocial> events) async* {
    // search and remove old calendars
    await deleteOldCalendars();
    // insert new calendars
    await insertNewCalendars();
    // add events
    final len = events.length;
    for (int i = 0; i < len; i++) {
      await calendarApi.events
          .insert(Event.fromJson(events[i].toJson()), currentCalendar.id);

      yield (i + 1) / len;
    }
  }
}
