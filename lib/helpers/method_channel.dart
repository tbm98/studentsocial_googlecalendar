import 'package:flutter/services.dart';
import 'log.dart';

class MethodChannelHelper {
  static const channel = MethodChannel('tbm.studentsocial/xlsreader');

  Future<String> pickerFile() async {
    try {
      final String result = await channel.invokeMethod('pickerFile');
      return result.trim();
    } on PlatformException catch (e) {
      logs('Failed to pick file: ${e.message}.');
      return '';
    }
  }
}
