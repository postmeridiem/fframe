extension StringExtension on String? {
  String? removeLeadingSlash() {
    if (this != null && this!.isNotEmpty && this!.startsWith('/')) {
      return this!.substring(1);
    }
    return this;
  }
}
