extension NumberHelper on int {
  String get format {
    if (this < 10) {
      return '0$this';
    }
    return toString();
  }
}
