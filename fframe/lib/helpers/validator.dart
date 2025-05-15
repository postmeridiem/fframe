part of '../../fframe.dart';

class Validator {
  bool validString(String? rawvalue) {
    // checks if a string is not empty,
    // for the rest anything is basically a valid string
    if (rawvalue!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool validInt(String? rawvalue) {
    // checks if the UI string is a safe integer
    if (rawvalue!.isNotEmpty) {
      return rawvalue is int;
    } else {
      return false;
    }
  }

  bool validUUID(String? rawvalue) {
    // pretty usesless. culling candidate unless a case arises soon
    return true;
  }

  bool validEmail(String? rawvalue) {
    // check if input is a valid email pattern
    if (rawvalue!.isNotEmpty) {
      return RegExp(r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+").hasMatch(rawvalue);
    } else {
      return false;
    }
  }

  bool validIcon(String? rawvalue) {
    // check if input is a valid icon
    // unsure how this is needed yet, since icon field should be an icon picket
    return true;
  }

  bool validateUrl(String? rawvalue) {
    // Check if input is a valid URL (might not cover all edge cases).
    // Starting with "http://" or "https://" is mandatory.
    if (rawvalue != null && rawvalue.isNotEmpty) {
      final urlRegex = RegExp(
        r"^(?:http:\/\/|https:\/\/)(?:[\w-]+\.)*[\w-]+(?:\/[\w\-\._~:/?#[\]@!\$&'()*+,;=.]*)?$",
        caseSensitive: false,
      );
      if (urlRegex.hasMatch(rawvalue)) {
        Uri? parsedValue = Uri.tryParse(rawvalue);
        return parsedValue != null;
      }
    }
    return false;
  }
}
