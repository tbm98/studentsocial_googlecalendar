extension StringHelper on String {
  Duration toDuration() {
    if (split(':').length != 2) {
      return null;
    }
    final vars = split(':');
    return Duration(hours: vars[0].toInt(), minutes: vars[1].toInt());
  }

  int toInt() {
    return int.parse(this);
  }

  DateTime toDDMMYYYY() {
    final vars = split('/');
    return DateTime(vars[2].toInt(), vars[1].toInt(), vars[0].toInt());
  }
}
