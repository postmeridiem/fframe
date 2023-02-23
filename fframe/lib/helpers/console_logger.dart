import 'package:flutter/material.dart';

class Console {
  static final Console instance = Console._internal();

// stores the current config
  late LogLevel logThreshold;

  Console._internal();

  factory Console({LogLevel logThreshold = LogLevel.dev}) {
    instance.logThreshold = logThreshold;
    return instance;
  }

  static void log(
    String message, {
    String scope = "fframeLog.unspecified",
    LogLevel level = LogLevel.prod,
  }) {
    LogLevel logThreshold = Console.instance.logThreshold;
    switch (logThreshold) {
      case LogLevel.fframe:
        if (level == LogLevel.fframe ||
            level == LogLevel.dev ||
            level == LogLevel.prod) {
          // show all log prints
          debugPrint("$scope: $message");
        }
        break;
      case LogLevel.dev:
        if (level == LogLevel.dev || level == LogLevel.prod) {
          // show all log prints with level warning or error
          debugPrint("$scope: $message");
        }
        break;
      case LogLevel.prod:
        if (level == LogLevel.prod) {
          // show all log prints with level error
          debugPrint(message);
        }
        break;
      default:
    }
  }
}

enum LogLevel {
  fframe,
  dev,
  prod,
}
