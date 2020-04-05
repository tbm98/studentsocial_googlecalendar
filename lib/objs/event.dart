import 'schedule.dart';

class EventStudentSocial {
  EventStudentSocial(this.schedule);

  final Schedule schedule;

  Map<String, dynamic> toJson() {
    return {
      'summary': schedule.classs,
      'location': schedule.address,
      'description': schedule.description,
      'start': {
        'dateTime': schedule.start.toIso8601String(),
        'timeZone': 'Asia/Ho_Chi_Minh'
      },
      'end': {
        'dateTime': schedule.end.toIso8601String(),
        'timeZone': 'Asia/Ho_Chi_Minh'
      },
      'reminders': {
        'useDefault': false,
        'overrides': [
          {'method': 'popup', 'minutes': 30}
        ]
      }
    };
  }
}
