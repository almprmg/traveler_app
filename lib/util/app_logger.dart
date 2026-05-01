import 'package:flutter/foundation.dart';

/// A reusable logger class that ONLY works in debug mode
/// In release/profile builds, all logging is completely disabled
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  // ANSI color codes for terminal output
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _green = '\x1B[32m';
  static const String _cyan = '\x1B[36m';
  static const String _magenta = '\x1B[35m';

  // Enable/disable colors (useful for some IDEs that don't support ANSI colors)
  static bool useColors = true;

  // Enable/disable timestamps
  static bool showTimestamp = true;

  /// IMPORTANT: This logger ONLY works in debug mode
  /// Returns true if logging is enabled (debug mode only)
  static bool get isEnabled => kDebugMode;

  /// Log an informational message (DEBUG MODE ONLY)
  static void info(String message, {String? tag}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    _log(message, level: 'INFO', color: _blue, tag: tag);
  }

  /// Log a debug message (DEBUG MODE ONLY)
  static void debug(String message, {String? tag}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    _log(message, level: 'DEBUG', color: _cyan, tag: tag);
  }

  /// Log a warning message (DEBUG MODE ONLY)
  static void warning(String message, {String? tag}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    _log(message, level: 'WARN', color: _yellow, tag: tag);
  }

  /// Log an error message (DEBUG MODE ONLY)
  static void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    _log(message, level: 'ERROR', color: _red, tag: tag);
    if (error != null) {
      _log('Error: $error', level: 'ERROR', color: _red, tag: tag);
    }
    if (stackTrace != null) {
      _log('StackTrace: $stackTrace', level: 'ERROR', color: _red, tag: tag);
    }
  }

  /// Log a success message (DEBUG MODE ONLY)
  static void success(String message, {String? tag}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    _log(message, level: 'SUCCESS', color: _green, tag: tag);
  }

  /// Log network/API related messages (DEBUG MODE ONLY)
  static void network(String message, {String? tag}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    _log(message, level: 'NETWORK', color: _magenta, tag: tag);
  }

  /// Log navigation events (DEBUG MODE ONLY)
  static void navigation(String message, {String? tag}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    _log(message, level: 'NAV', color: _cyan, tag: tag);
  }

  /// Log JSON data (pretty printed) (DEBUG MODE ONLY)
  static void json(dynamic data, {String? tag}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds

    try {
      final String prettyJson = _prettyPrintJson(data);
      _log(prettyJson, level: 'JSON', color: _green, tag: tag);
    } catch (e) {
      error('Failed to print JSON: $e', tag: tag);
    }
  }

  /// Log a separator line (DEBUG MODE ONLY)
  static void separator({String char = '=', int length = 80}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    if (kDebugMode) {
      print(char * length);
    }
  }

  /// Log a header with surrounding lines (DEBUG MODE ONLY)
  static void header(String message, {String char = '='}) {
    if (!kDebugMode) return; // Safety check - will be removed in release builds
    separator(char: char);
    info(message);
    separator(char: char);
  }

  /// Core logging method (PRIVATE - DEBUG MODE ONLY)
  static void _log(
    String message, {
    required String level,
    required String color,
    String? tag,
  }) {
    // Double safety check (though this should never be reached in release)
    if (!kDebugMode) return;

    final StringBuffer buffer = StringBuffer();

    // Add timestamp if enabled
    if (showTimestamp) {
      final String timestamp = _getTimestamp();
      buffer.write('[$timestamp] ');
    }

    // Add color if enabled
    if (useColors) {
      buffer.write(color);
    }

    // Add level
    buffer.write('[$level]');

    // Add tag if provided
    if (tag != null && tag.isNotEmpty) {
      buffer.write(' [$tag]');
    }

    // Reset color if enabled
    if (useColors) {
      buffer.write(_reset);
    }

    // Add message
    buffer.write(' $message');

    // Only print in debug mode
    if (kDebugMode) {
      print(buffer.toString());
    }
  }

  /// Get formatted timestamp (PRIVATE)
  static String _getTimestamp() {
    final DateTime now = DateTime.now();
    return '${_pad(now.hour)}:${_pad(now.minute)}:${_pad(now.second)}.${_pad(now.millisecond, 3)}';
  }

  /// Pad numbers with zeros (PRIVATE)
  static String _pad(int value, [int width = 2]) {
    return value.toString().padLeft(width, '0');
  }

  /// Pretty print JSON (PRIVATE)
  static String _prettyPrintJson(dynamic data) {
    try {
      if (data is String) {
        return data;
      }

      // For simple objects, just convert to string
      if (data is! Map && data is! List) {
        return data.toString();
      }

      // For complex objects, create indented structure
      return _formatJson(data);
    } catch (e) {
      return data.toString();
    }
  }

  /// Format JSON with indentation (PRIVATE)
  static String _formatJson(dynamic data, [int indent = 0]) {
    final String indentStr = '  ' * indent;
    final StringBuffer buffer = StringBuffer();

    if (data is Map) {
      buffer.writeln('{');
      final entries = data.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        buffer.write('$indentStr  "${entry.key}": ');

        if (entry.value is Map || entry.value is List) {
          buffer.write(_formatJson(entry.value, indent + 1));
        } else if (entry.value is String) {
          buffer.write('"${entry.value}"');
        } else {
          buffer.write(entry.value);
        }

        if (i < entries.length - 1) {
          buffer.writeln(',');
        } else {
          buffer.writeln();
        }
      }
      buffer.write('$indentStr}');
    } else if (data is List) {
      buffer.writeln('[');
      for (var i = 0; i < data.length; i++) {
        buffer.write('$indentStr  ');

        if (data[i] is Map || data[i] is List) {
          buffer.write(_formatJson(data[i], indent + 1));
        } else if (data[i] is String) {
          buffer.write('"${data[i]}"');
        } else {
          buffer.write(data[i]);
        }

        if (i < data.length - 1) {
          buffer.writeln(',');
        } else {
          buffer.writeln();
        }
      }
      buffer.write('$indentStr]');
    } else {
      buffer.write(data.toString());
    }

    return buffer.toString();
  }
}

/// Extension on Object for easy logging (DEBUG MODE ONLY)
extension LoggerExtension on Object {
  /// Log this object (DEBUG MODE ONLY)
  void log({String? tag}) {
    if (!kDebugMode) return; // Safety check
    AppLogger.info(toString(), tag: tag);
  }

  /// Log this object as JSON (DEBUG MODE ONLY)
  void logJson({String? tag}) {
    if (!kDebugMode) return; // Safety check
    AppLogger.json(this, tag: tag);
  }
}
