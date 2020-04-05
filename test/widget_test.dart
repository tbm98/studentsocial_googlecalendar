import 'package:flutter_test/flutter_test.dart';
import 'package:studentsocialgooglecalendar/helpers/date.dart';
import 'package:studentsocialgooglecalendar/helpers/log.dart';

void main() {
  test('Unit test', () async {
    final DateHelper dateHelper = DateHelper.instance;
    logs(dateHelper.getThoiGian('3')[0]);
    logs(dateHelper.getThoiGian('3')[1]);
  });
}
