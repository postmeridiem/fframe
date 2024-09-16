part of '../fframe.dart';

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
    String scope = "fframeLog.global",
    LogLevel level = LogLevel.prod,
    ConsoleColor color = ConsoleColor.standard,
  }) {
    LogLevel logThreshold = Console.instance.logThreshold;
    switch (logThreshold) {
      case LogLevel.fframe:
        if (level == LogLevel.fframe || level == LogLevel.dev || level == LogLevel.prod) {
          // show all log prints
          debugPrint("${color.colorCode}$scope: $message${ConsoleColor.standard.colorCode}");
        }
        break;
      case LogLevel.dev:
        if (level == LogLevel.dev || level == LogLevel.prod) {
          // show all log prints with level warning or error
          debugPrint("${color.colorCode}$scope: $message${ConsoleColor.standard.colorCode}");
        }
        break;
      case LogLevel.prod:
        if (level == LogLevel.prod) {
          // show all log prints with level error
          debugPrint("${color.colorCode}$message)${ConsoleColor.standard.colorCode}");
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

enum ConsoleColor {
  black("\x1B[30m"),
  red("\x1B[31m"),
  green("\x1B[32m"),
  yellow("\x1B[33m"),
  blue("\x1B[34m"),
  magenta("\x1B[35m"),
  cyan("\x1B[36m"),
  white("\x1B[37m"),
  standard("\x1B[0m");

  const ConsoleColor(this.colorCode);
  final String colorCode;
}
