import 'package:flutter/material.dart';

/// Minimal unit test harness for core services testing.
/// This version doesn't import the full fframe package to avoid web dependencies.
void setupUnitTests() {
  // For core service testing, we don't need the full fframe initialization
  // Just ensure Flutter test environment is ready
  WidgetsFlutterBinding.ensureInitialized();
}