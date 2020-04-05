import '../helpers/date.dart';
import '../helpers/string.dart';

class Schedule {
  Schedule(this.classs, this.address, this.type, this.lecturer, this.lesson,
      this.day);

  String classs, address, type, lecturer, lesson;

  DateTime day;

  DateTime get start {
    final durations = DateHelper.instance.getThoiGian(lessonTime);
    return day.add(durations[0]);
  }

  DateTime get end {
    final durations = DateHelper.instance.getThoiGian(lessonTime);
    return day.add(durations[1]);
  }

  String get startString {
    return start.toIso8601String();
  }

  String get endString {
    return end.toIso8601String();
  }

  String get lessonTime {
    // 8->10 => 8,9,10
    final vars = lesson.split('->');
    final int from = vars[0].toInt();
    final int to = vars[1].toInt();
    String result = '$from';
    for (int i = from + 1; i <= to; i++) {
      result += ',$i';
    }
    return result;
  }

  String get description {
    return 'Tiết: $lessonTime\nGiảng viên: $lecturer\nKiểu: $type';
  }
}
