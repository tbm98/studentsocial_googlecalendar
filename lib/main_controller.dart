import 'package:flutter/foundation.dart';
import 'helpers/calendar_service_communicate.dart';
import 'helpers/google_http_client.dart';
import 'helpers/google_sign_in.dart';
import 'helpers/log.dart';
import 'helpers/method_channel.dart';
import 'objs/calendar.dart';
import 'objs/event.dart';
import 'objs/login_result.dart';
import 'objs/row_excel.dart';
import 'objs/schedule.dart';

enum StateAction { notLogin, logined, imported, uploaded }

class MainController with ChangeNotifier {
  GoogleSignInHelper googleSignInHelper = GoogleSignInHelper();
  MethodChannelHelper methodChannelHelper = MethodChannelHelper();
  CalendarServiceCommunicate calendarServiceCommunicate;
  StateAction stateAction = StateAction.notLogin;
  bool loading = false;
  double loadingValue;
  String avatarUrl = '';
  LoginResult loginResult;
  List<EventStudentSocial> events = [];

  void loginDone(LoginResult result) {
    loginResult = result;
    avatarUrl = loginResult.firebaseUser.photoUrl;
  }

  void clicked() async {
    if (stateAction == StateAction.notLogin) {
      loginAction();
    } else if (stateAction == StateAction.logined) {
      importAction();
    } else if (stateAction == StateAction.imported) {
      uploadAction();
    }
  }

  void loginAction() async {
    loading = true;
    notifyListeners();
    final result = await googleSignInHelper.signInWithGoogle();

    loading = false;
    loginDone(result);
    if (avatarUrl.isNotEmpty) {
      stateAction = StateAction.logined;
    }
    notifyListeners();
  }

  void importAction() async {
    loading = true;
    notifyListeners();
    final result = await methodChannelHelper.pickerFile();
    logs(result);
    loading = false;
    if (result.isEmpty) {
      notifyListeners();
      return;
    }

    final List<RowExcel> rows = parseListRow(result);
    for (final row in rows) {
      DateTime start = row.start;
      final end = row.end;
      while (start != end) {
        if (start.weekday == row.weekday) {
          // add schedule to map
          final schedule = Schedule(row.classs, row.address, row.type,
              row.lecturer, row.lesson, start);
          events.add(EventStudentSocial(schedule));
        }

        start = start.add(const Duration(days: 1));
        // weekday + 1 = ngày hiện tại
        // vd: nay thứ 2 thì weekday = 1
      }
    }
    stateAction = StateAction.imported;
    notifyListeners();
  }

  void uploadAction() async {
    loading = true;
    notifyListeners();

    calendarServiceCommunicate =
        CalendarServiceCommunicate(GoogleHttpClient(loginResult.headers));
    await calendarServiceCommunicate.deleteOldCalendars();
    final calendar = await calendarServiceCommunicate.insertNewCalendars();
    if (calendar.summary != CalendarStudentSocial.summary) {
      return;
    }

    calendarServiceCommunicate.addEvents(events).listen((value) {
      loadingValue = value;
      if (loadingValue == 1) {
        loadingValue = null;
        loading = false;
        stateAction = StateAction.uploaded;
      }
      notifyListeners();
    });
  }

  void currentActionDone() async {
    if (stateAction == StateAction.uploaded) {
      return;
    }
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    switch (stateAction) {
      case StateAction.notLogin:
        stateAction = StateAction.logined;
        break;
      case StateAction.logined:
        stateAction = StateAction.imported;
        break;
      case StateAction.imported:
        stateAction = StateAction.uploaded;
        break;
      default:
        break;
    }
    loading = false;
    notifyListeners();
  }
}
