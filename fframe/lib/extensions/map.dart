extension MapExtensions<K, V> on Map<K, V> {
  V? firstWhereOrNull(bool Function(K key, V value) test) {
    for (final entry in entries) {
      if (test(entry.key, entry.value)) return entry.value;
    }
    return null;
  }
}
