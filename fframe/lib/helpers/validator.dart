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
    return true;
  }

  bool validUUID(String? rawvalue) {
    // pretty usesless. culling candidate unless a case arises soon
    return true;
  }

  bool validEmail(String? rawvalue) {
    // check if input is a valid email pattern
    return true;
  }

  bool validIcon(String? rawvalue) {
    // check if input is a valid icon
    // unsure how this is needed yet, since icon field should be an icon picket
    return true;
  }
}
