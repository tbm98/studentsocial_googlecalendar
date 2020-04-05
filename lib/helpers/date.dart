import 'number.dart';
import 'string.dart';

class DateHelper {
  DateHelper._() {
    _now = DateTime.now();
  }

  DateHelper.fromDate(this._now);

  DateHelper.frommUTC(int y, int m, int d) {
    _now = DateTime(y, m, d);
  }

  static DateHelper _instance;
  DateTime _now;
  static const _time1 = [
    '06:30 - 07:20',
    '07:25 - 08:15',
    '08:25 - 09:15',
    '09:25 - 10:15',
    '10:20 - 11:10',
    '13:00 - 13:50',
    '13:55 - 14:45',
    '14:55 - 15:45',
    '15:55 - 16:45',
    '16:50 - 17:40',
    '18:15 - 19:05',
    '19:10 - 20:00'
  ];

  static const _time2 = [
    '06:45 - 07:35',
    '07:40 - 08:30',
    '08:40 - 09:30',
    '09:40 - 10:30',
    '10:35 - 11:25',
    '13:00 - 13:50',
    '13:55 - 14:45',
    '14:55 - 15:45',
    '15:55 - 16:45',
    '16:50 - 17:40',
    '18:15 - 19:05',
    '19:10 - 20:00'
  ];

  static DateHelper get instance {
    return _instance ??= DateHelper._();
  }

  String format(DateTime date) {
    return '${date.year.format}-${date.month.format}-${date.day.format}';
  }

  DateTime getDate(int day) {
    final DateTime date = DateTime(getYear(), getMonth(), getDay(), 19, 30);
    return date.add(Duration(days: day));
  }

  DateTime getDateNow() {
    return _now;
  }

  int getDay() {
    return _now.day;
  }

  int getMonth() {
    return _now.month;
  }

  int getYear() {
    return _now.year;
  }

  int getDayOfWeek() {
    return _now.weekday;
  }

  int getMaxDayOfMonth(int year, int month) {
//    print(DateTime(year,month+1,0));
    //datetime(year,month+1,0) tuong duong voi ngay cuoi cung cua thang truoc no
    // 0/12/2018 => 30/11/2018
    return DateTime(year, month + 1, 0).day;
  }

  int getIndexDayOfWeek(int year, int month) {
    return DateTime(year, month, 1).weekday;
  }

  int getMonthByIndex(int index, int mode) {
    final int delta = index - 12; // 12 la indexpage mac dinh
    if (mode == 1) {
      return DateTime(_now.year, _now.month + delta, _now.day).month;
    } else {
      return DateTime(_now.year, _now.month + delta, _now.day).year;
    }
  }

  int get mua {
    /**
     * return 1 neu la mua he
     * return 2 neu la mua dong
     * mua he bat dau tu 15/4
     * mua dong bat dau tu 15/10
     */
    final int m = _now.month;
    final int d = _now.day;
    if ([1, 2, 3, 11, 12].contains(m)) {
      return 2;
    }
    if (m == 4) {
      if (d >= 15) {
        return 1;
      } else {
        return 2;
      }
    }
    if (m == 10) {
      if (d >= 15) {
        return 2;
      } else {
        return 1;
      }
    }
    return 1;
  }

  int get tiet {
    final List<String> time = _getTimeByMua();
    String _time1;
    String _time2;
    int h1;
    int m1;
    int h2;
    int m2;
    int date1;
    int date2;

    for (int i = 0; i < time.length; i++) {
      _time1 = time[i].split('-')[0];
      _time2 = time[i].split('-')[1];
      h1 = int.parse(_time1.split(':')[0]);
      m1 = int.parse(_time1.split(':')[1]);
      h2 = int.parse(_time2.split(':')[0]);
      m2 = int.parse(_time2.split(':')[1]);
      date1 = DateTime(_now.year, _now.month, _now.day, h1, m1)
          .millisecondsSinceEpoch;
      date2 = DateTime(_now.year, _now.month, _now.day, h2, m2)
          .millisecondsSinceEpoch;
      if (DateTime.now().millisecondsSinceEpoch >= date1 &&
          DateTime.now().millisecondsSinceEpoch <= date2) {
        return i + 1;
      }
    }
    return 0;
  }

  List<String> _getTimeByMua() {
    if (mua == 1) {
      return _time1;
    }
    return _time2;
  }

  List<Duration> getThoiGian(String thoiGian) {
    final int muaHT = mua;
    Duration start, end;

    if (thoiGian.contains(',')) {
      //co nhieu hon 1 tiet
      final tiets = thoiGian.split(',');
      final int first = int.parse(tiets[0]);
      final int last = int.parse(tiets[tiets.length - 1]);

      if (muaHT == 1) {
        //mua he lay lich _time1
        start = _time1[first - 1].split('-')[0].toDuration();
        end = _time1[last - 1].split('-')[1].toDuration();
      } else {
        start = _time2[first - 1].split('-')[0].toDuration();
        end = _time2[last - 1].split('-')[1].toDuration();
      }
    } else {
      //chi co 1 tiet :v
      final int tiet = int.parse(thoiGian);
      if (muaHT == 1) {
        //mua he lay lich _time1
        start = _time1[tiet - 1].split('-')[0].toDuration();
        end = _time1[tiet - 1].split('-')[1].toDuration();
      } else {
        start = _time2[tiet - 1].split('-')[0].toDuration();
        end = _time2[tiet - 1].split('-')[1].toDuration();
      }
    }
    return [start, end];
  }

  int get hour {
    return _now.hour;
  }

  int get minute {
    return _now.minute;
  }
}
