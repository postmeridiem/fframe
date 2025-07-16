String getSlug(String input) {
  // Trim function
  String trim(String charlist) {
    return input
        .replaceAll('.', '-')
        .replaceAll('\'', '-')
        // Replace occurrences of '[', ']', and ''' with '-'
        .replaceAll(RegExp(r'[\[\]]+'), '-')
        // Replace occurrences of '{{}}' with '-'
        .replaceAll(RegExp(r'\{\{\}\}+'), '-')
        // Replace tilde with hyphens
        .replaceAll('~', '-')
        // Replace dollar sign with hyphens
        .replaceAll('\$', '-')
        // Replace pound sign with hyphens
        .replaceAll('#', '-')
        // Replace question mark with hyphens
        .replaceAll('?', '-')
        // Replace plus sign with 'plus'
        .replaceAll('+', 'plus')
        // Replace spaces with hyphens
        .replaceAll(' ', '-')
        // Replace underscores with hyphens
        .replaceAll('_', '-')
        // Remove registered trademark symbol
        .replaceAll('®', '')
        // Replace backslashes with hyphens
        .replaceAll('\\', '-')
        // Replace double quotes with hyphens
        .replaceAll('"', '-')
        // Replace greater-than sign with hyphens
        .replaceAll('>', '-')
        // Replace single quotes with hyphens
        .replaceAll('\'', '-')
        // Replace opening parentheses with hyphens
        .replaceAll('(', '-')
        // Replace closing parentheses with hyphens
        .replaceAll(')', '-')
        // Replace '*' with ''
        .replaceAll('*', '')
        // Replace '&' with ''
        .replaceAll('&', '')
        // Replace consecutive hyphens with a single hyphen
        .replaceAll(RegExp(r'--+'), '-')
        // Use regular expression to trim leading and trailing hyphens and asterisks, then convert to lowercase
        .replaceAll(RegExp(r'^[-*]+|[-*]+$'), '')
        .toLowerCase();
  }

  // Character conversion list
  final Map<String, String> conversions = {
    'ae': 'ä|æ|ǽ|Ä|Æ|Ǽ',
    'oe': 'ö|œ|Ö|Œ',
    'ue': 'ü|Ü',
    'a': 'à|á|â|ã|å|ǻ|ā|ă|ą|ǎ|ª|À|Á|Â|Ã|Ä|Å|Ǻ|Ā|Ă|Ą|Ǎ',
    'c': 'ç|ć|ĉ|ċ|č|Ç|Ć|Ĉ|Ċ|Č',
    'd': 'ð|ď|đ|Ð|Ď|Đ',
    'e': 'è|é|ê|ë|ē|ĕ|ė|ę|ě|È|É|Ê|Ë|Ē|Ĕ|Ė|Ę|Ě',
    'f': 'ƒ',
    'g': 'ĝ|ğ|ġ|ģ|Ĝ|Ğ|Ġ|Ģ',
    'h': 'ĥ|ħ|Ĥ|Ħ',
    'i': 'ì|í|î|ï|ĩ|ī|ĭ|ǐ|į|ı|Ì|Í|Î|Ï|Ĩ|Ī|Ĭ|Ǐ|Į|İ',
    'j': 'ĵ|Ĵ',
    'k': 'ķ|Ķ',
    'l': 'ĺ|ļ|ľ|ŀ|ł|Ĺ|Ļ|Ľ|Ŀ|Ł',
    'n': 'ñ|ń|ņ|ň|ŉ|Ñ|Ń|Ņ|Ň',
    'o': 'ò|ó|ô|õ|ō|ŏ|ǒ|ő|ơ|ø|ǿ|º|Ò|Ó|Ô|Õ|Ō|Ŏ|Ǒ|Ő|Ơ|Ø|Ǿ',
    'r': 'ŕ|ŗ|ř|Ŕ|Ŗ|Ř',
    's': 'ś|ŝ|ş|š|ſ|Ś|Ŝ|Ş|Š',
    't': 'ţ|ť|ŧ|Ţ|Ť|Ŧ',
    'u': 'ù|ú|û|ũ|ū|ŭ|ů|ű|ų|ư|ǔ|ǖ|ǘ|ǚ|ǜ|Ù|Ú|Û|Ũ|Ū|Ŭ|Ů|Ű|Ų|Ư|Ǔ|Ǖ|Ǘ|Ǚ|ǜ',
    'y': 'ý|ÿ|ŷ|Ý|Ÿ|Ŷ',
    'w': 'ŵ|Ŵ',
    'z': 'ź|ż|ž|Ź|Ż|Ž',
    'ss': 'ß',
    'ij': 'ĳ|Ĳ',
    'nbsp': String.fromCharCode(160),
  };

  conversions.forEach((key, value) {
    final re = RegExp(value);
    input = input.replaceAll(re, key);
  });

  return trim(r'\s'); // Use the actual trim character list
}
