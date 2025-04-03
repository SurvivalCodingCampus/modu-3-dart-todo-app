import 'dart:io';

import 'package:intl/intl.dart';

class LogService {
  final File? _logFile;

  LogService(String logFilePath) : _logFile = File(logFilePath);

  Future<void> log(String message) async {
    await _logFile?.writeAsString(
      mode: FileMode.append,
      "[${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}] $message\n",
    );
  }
}
