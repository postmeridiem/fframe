/// Test timing utilities for performance benchmarking
/// 
/// Provides non-intrusive timing wrappers for standard test functions:
/// - timedTest() for unit tests
/// - timedTestWidgets() for widget tests  
/// - timedGroup() for test groups
/// 
/// All timing data is automatically written to llm-scratchspace/timing/ as JSON files.
library test_timing;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Performance categories based on test type and execution time
enum TestPerformance {
  fast,
  moderate,
  slow,
}

/// Test type for determining performance thresholds
enum TestType {
  unit,
  widget,
  integration,
}

/// Individual test timing result
class TestTimingResult {
  final String name;
  final String file;
  final int durationMs;
  final TestPerformance category;
  final bool thresholdExceeded;
  final TestType testType;

  TestTimingResult({
    required this.name,
    required this.file,
    required this.durationMs,
    required this.category,
    required this.thresholdExceeded,
    required this.testType,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'file': file,
    'duration_ms': durationMs,
    'category': category.name,
    'threshold_exceeded': thresholdExceeded,
  };
}

/// Test timing session data
class TestTimingSession {
  final DateTime timestamp;
  final TestType testType;
  final List<TestTimingResult> tests;

  TestTimingSession({
    required this.timestamp,
    required this.testType,  
    required this.tests,
  });

  Map<String, dynamic> toJson() {
    final fastTests = tests.where((t) => t.category == TestPerformance.fast).length;
    final moderateTests = tests.where((t) => t.category == TestPerformance.moderate).length;
    final slowTests = tests.where((t) => t.category == TestPerformance.slow).length;
    final totalDuration = tests.fold<int>(0, (sum, test) => sum + test.durationMs);
    final averageDuration = tests.isNotEmpty ? totalDuration / tests.length : 0.0;

    return {
      'test_run_timestamp': timestamp.toIso8601String(),
      'test_type': testType.name,
      'tests': tests.map((t) => t.toJson()).toList(),
      'summary': {
        'total_tests': tests.length,
        'fast_tests': fastTests,
        'moderate_tests': moderateTests,
        'slow_tests': slowTests,
        'average_duration_ms': averageDuration,
        'total_duration_ms': totalDuration,
      }
    };
  }
}

/// Global timing data collector
class _TimingCollector {
  static final _TimingCollector _instance = _TimingCollector._internal();
  factory _TimingCollector() => _instance;
  _TimingCollector._internal();

  final List<TestTimingResult> _results = [];
  TestType? _currentTestType;

  void setTestType(TestType testType) {
    _currentTestType = testType;
  }

  void addResult(TestTimingResult result) {
    _results.add(result);
  }

  void writeResults() {
    if (_results.isEmpty || _currentTestType == null) return;

    final session = TestTimingSession(
      timestamp: DateTime.now(),
      testType: _currentTestType!,
      tests: List.from(_results),
    );

    _writeTimingFile(session);
    _results.clear();
  }

  void _writeTimingFile(TestTimingSession session) {
    // Check for benchmark mode using a web-compatible approach
    final benchmarkMode = _getBenchmarkMode();
    
    // Always show timing data in benchmark mode, regardless of file I/O success
    if (benchmarkMode) {
      debugPrint('📊 Timing Results Collected:');
      _printSummary(session);
      _printDetailedResults(session);
    }
    
    // Skip file operations on web platform
    if (kIsWeb) {
      if (benchmarkMode) {
        debugPrint('📝 File output skipped (web platform)');
      }
      return;
    }
    
    try {
      // Tests run from example/ directory, so go up one level then into llm-scratchspace/timing
      const timingDirPath = '../llm-scratchspace/timing';
      
      final timingDir = Directory(timingDirPath);
      if (!timingDir.existsSync()) {
        timingDir.createSync(recursive: true);
      }

      final filename = '${session.testType.name}_tests_timing.json';
      final filePath = '$timingDirPath${Platform.pathSeparator}$filename';
      final file = File(filePath);
      
      final jsonString = const JsonEncoder.withIndent('  ').convert(session.toJson());
      file.writeAsStringSync(jsonString);

      // Also update timing summary
      _updateTimingSummary(session, timingDir);
      
      if (benchmarkMode) {
        debugPrint('📊 Timing data written to: ${file.path}');
      }
    } catch (e) {
      // Don't fail tests due to timing file issues
      if (benchmarkMode) {
        debugPrint('⚠️ Could not write timing file: $e');
      }
    }
  }

  bool _getBenchmarkMode() {
    // Web-compatible way to check for benchmark mode
    if (kIsWeb) {
      // On web, we'll default to showing timing data since we can't read environment variables
      return true;
    } else {
      try {
        return Platform.environment['BENCHMARK_MODE'] == 'true';
      } catch (e) {
        return false;
      }
    }
  }

  void _printDetailedResults(TestTimingSession session) {
    debugPrint('📋 Individual Test Timings:');
    for (final test in session.tests) {
      final icon = test.category == TestPerformance.fast 
          ? '🟢' 
          : test.category == TestPerformance.moderate 
              ? '🟡' 
              : '🔴';
      debugPrint('   $icon ${test.name}: ${test.durationMs}ms (${test.category.name})');
    }
  }


  void _updateTimingSummary(TestTimingSession session, Directory timingDir) {
    final summaryFile = File('${timingDir.path}${Platform.pathSeparator}timing_summary.json');
    
    Map<String, dynamic> summary;
    if (summaryFile.existsSync()) {
      try {
        summary = jsonDecode(summaryFile.readAsStringSync());
      } catch (e) {
        summary = {'test_sessions': []};
      }
    } else {
      summary = {'test_sessions': []};
    }

    final sessions = summary['test_sessions'] as List;
    sessions.add({
      'timestamp': session.timestamp.toIso8601String(),
      'test_type': session.testType.name,
      'summary': session.toJson()['summary'],
    });

    // Keep only last 10 sessions per test type
    final groupedSessions = <String, List>{};
    for (final s in sessions) {
      final testType = s['test_type'] as String;
      groupedSessions[testType] = (groupedSessions[testType] ?? [])..add(s);
    }

    final trimmedSessions = <Map<String, dynamic>>[];
    for (final entry in groupedSessions.entries) {
      final sessions = entry.value.cast<Map<String, dynamic>>();
      sessions.sort((a, b) => (b['timestamp'] as String).compareTo(a['timestamp'] as String));
      trimmedSessions.addAll(sessions.take(10));
    }

    summary['test_sessions'] = trimmedSessions;
    summary['last_updated'] = DateTime.now().toIso8601String();

    final jsonString = const JsonEncoder.withIndent('  ').convert(summary);
    summaryFile.writeAsStringSync(jsonString);
  }

  void _printSummary(TestTimingSession session) {
    final summary = session.toJson()['summary'] as Map<String, dynamic>;
    debugPrint('📈 Test Performance Summary:');
    debugPrint('   Total: ${summary['total_tests']} tests');
    debugPrint('   Fast: ${summary['fast_tests']} | Moderate: ${summary['moderate_tests']} | Slow: ${summary['slow_tests']}');
    debugPrint('   Average: ${(summary['average_duration_ms'] as double).toStringAsFixed(1)}ms');
    debugPrint('   Total Duration: ${summary['total_duration_ms']}ms');
  }
}

/// Performance thresholds by test type (in milliseconds)
const Map<TestType, Map<TestPerformance, int>> _performanceThresholds = {
  TestType.unit: {
    TestPerformance.fast: 10,
    TestPerformance.moderate: 50,
  },
  TestType.widget: {
    TestPerformance.fast: 100,
    TestPerformance.moderate: 500,
  },
  TestType.integration: {
    TestPerformance.fast: 500,
    TestPerformance.moderate: 2000,
  },
};

/// Categorize test performance based on duration and test type
TestPerformance _categorizePerformance(int durationMs, TestType testType) {
  final thresholds = _performanceThresholds[testType]!;
  
  if (durationMs < thresholds[TestPerformance.fast]!) {
    return TestPerformance.fast;
  } else if (durationMs < thresholds[TestPerformance.moderate]!) {
    return TestPerformance.moderate;
  } else {
    return TestPerformance.slow;
  }
}

/// Get current test file name from stack trace
String _getCurrentTestFile() {
  try {
    final stack = StackTrace.current.toString();
    final lines = stack.split('\n');
    
    for (final line in lines) {
      if (line.contains('_test.dart') && line.contains('file://')) {
        final match = RegExp(r'file://.*?([^/]+_test\.dart)').firstMatch(line);
        if (match != null) {
          return match.group(1)!;
        }
      }
    }
    
    // Fallback: look for any .dart file in stack
    for (final line in lines) {
      final match = RegExp(r'([^/\s]+\.dart)').firstMatch(line);
      if (match != null) {
        return match.group(1)!;
      }
    }
  } catch (e) {
    // Ignore stack trace parsing errors
  }
  
  return 'unknown_test.dart';
}

/// Timed version of standard test() function for unit tests
void timedTest(
  String description,
  dynamic Function() body, {
  String? testOn,
  Timeout? timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  _TimingCollector().setTestType(TestType.unit);
  
  test(description, () async {
    final stopwatch = Stopwatch()..start();
    
    try {
      await body();
    } finally {
      stopwatch.stop();
      
      final durationMs = stopwatch.elapsedMilliseconds;
      final category = _categorizePerformance(durationMs, TestType.unit);
      final thresholdExceeded = category == TestPerformance.slow;
      
      final result = TestTimingResult(
        name: description,
        file: _getCurrentTestFile(),
        durationMs: durationMs,
        category: category,
        thresholdExceeded: thresholdExceeded,
        testType: TestType.unit,
      );
      
      _TimingCollector().addResult(result);
    }
  }, testOn: testOn, timeout: timeout, skip: skip, tags: tags, onPlatform: onPlatform, retry: retry);
}

/// Timed version of standard testWidgets() function for widget tests
void timedTestWidgets(
  String description,
  WidgetTesterCallback callback, {
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) {
  _TimingCollector().setTestType(TestType.widget);
  
  testWidgets(description, (tester) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      await callback(tester);
    } finally {
      stopwatch.stop();
      
      final durationMs = stopwatch.elapsedMilliseconds;
      final category = _categorizePerformance(durationMs, TestType.widget);
      final thresholdExceeded = category == TestPerformance.slow;
      
      final result = TestTimingResult(
        name: description,
        file: _getCurrentTestFile(),
        durationMs: durationMs,
        category: category,
        thresholdExceeded: thresholdExceeded,
        testType: TestType.widget,
      );
      
      _TimingCollector().addResult(result);
    }
  }, skip: skip, timeout: timeout, semanticsEnabled: semanticsEnabled, variant: variant, tags: tags);
}

/// Timed version of standard group() function
/// Note: This times the entire group execution, not individual tests
void timedGroup(String description, void Function() body, {dynamic skip}) {
  group(description, () {
    final stopwatch = Stopwatch()..start();
    
    try {
      body();
    } finally {
      stopwatch.stop();
      // Group timing is mainly for organizational purposes
      // Individual test timings are more important
    }
  }, skip: skip);
}

/// Write accumulated timing results to files
/// Call this in tearDownAll() or similar cleanup
void writeTimingResults() {
  _TimingCollector().writeResults();
}

/// Setup timing collection for a test file
/// Call this in main() of test files to ensure timing data is written
void setupTiming(TestType testType) {
  _TimingCollector().setTestType(testType);
  
  // Ensure timing results are written when tests complete
  tearDownAll(() {
    writeTimingResults();
  });
}