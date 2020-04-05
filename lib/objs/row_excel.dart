import '../helpers/log.dart';
import '../helpers/string.dart';

class RowExcel {
  RowExcel(this.weekdays, this.lesson, this.timeline, this.classs, this.type,
      this.address, this.lecturer);

  factory RowExcel.fromString(String value) {
    final element = value.split('|');
    logs('value is $element');
    if (element.length <= 1) {
      return null;
    }
    return RowExcel(element[0], element[1], element[2], element[3], element[4],
        element[5], element[6]);
  }

  String weekdays, lesson, timeline, classs, type, address, lecturer;

  DateTime get start {
    final times = timeline.split('->');
    return times[0].toDDMMYYYY();
  }

  DateTime get end {
    final times = timeline.split('->');
    return times[1].toDDMMYYYY();
  }

  int get weekday {
    return weekdays[1].toInt() - 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'weekdays': weekdays,
      'lesson': lesson,
      'timeline': timeline,
      'classs': classs,
      'type': type,
      'address': address,
      'lecturer': lecturer,
    };
  }
}

List<RowExcel> parseListRow(String value) {
  final List<RowExcel> rowExcels = [];
  String weekday = '';
  value.split('\n').forEach((e) {
    final rows = RowExcel.fromString(e);

    // Kiểm tra nếu mà row này không có thứ nghĩa là nó sẽ thuộc thứ của
    // row trước nó.
    // mặc định row đầu tiên sẽ luôn có thứ.

    if (rows.weekdays.isNotEmpty) {
      weekday = rows.weekdays;
    } else {
      rows.weekdays = weekday;
    }
    if (rows != null) {
      rowExcels.add(rows);
    }
  });
  return rowExcels;
}
