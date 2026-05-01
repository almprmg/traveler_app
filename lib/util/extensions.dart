extension CleanMap on Map<String, dynamic> {
  Map<String, dynamic> removeNulls() {
    removeWhere((key, value) => value == null);
    return this;
  }
}