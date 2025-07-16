extension StringExtension on String? {
  String? removeLeadingSlash() {
    if (this != null && this!.isNotEmpty && this!.startsWith('/')) {
      return this!.substring(1);
    }
    return this;
  }

  String? toCapitalized() {
    if (this != null && this!.isNotEmpty) {
      return "${this![0].toUpperCase()}${this!.substring(1)}";
    }
    return this;
  }

  String? toTitleCase() {
    if (this == null) return null;
    return this!.split(' ').map((word) => word.toCapitalized()).join(' ');
  }
}

