import 'package:cloud_firestore/cloud_firestore.dart';

extension StartsWith<T> on Query<T> {
  Query<T> startsWith(String field, String searchTerm) {
    if (searchTerm.isEmpty) return this;
    // Work in Unicode scalar values (runes), not UTF-16 code units, so the
    // exclusive upper bound is computed correctly for non-BMP characters
    // (emoji, supplementary CJK). Incrementing only the first code unit of the
    // last grapheme produced a corrupt bound and wrong/empty results.
    final runes = searchTerm.runes.toList();
    final lastRune = runes.removeLast();
    final baseQuery = where(field, isGreaterThanOrEqualTo: searchTerm);
    final nextRune = lastRune + 1;
    // Skip the upper bound if the successor is a surrogate or beyond the max
    // code point, rather than building an invalid string.
    if (nextRune > 0x10FFFF || (nextRune >= 0xD800 && nextRune <= 0xDFFF)) {
      return baseQuery;
    }
    final limit = String.fromCharCodes([...runes, nextRune]);
    return baseQuery.where(field, isLessThan: limit);
  }
}
