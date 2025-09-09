import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class Log{
  static final Log _instance = Log._internal();

  factory Log() {
    return _instance;
  }
  
  Log._internal();

  static void info(String message) {
    if (kDebugMode) {
      developer.log(message, name: "INFO");
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      developer.log(message, name: "WARNING");
    }
  }

  static void error(String message) {
    if (kDebugMode) {
      developer.log(message, name: "ERROR");
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      developer.log(message, name: "DEBUG");
    }
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(message, name: "ERROR", error: error, stackTrace: stackTrace);
    }
  }
}
