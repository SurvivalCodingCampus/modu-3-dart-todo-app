import 'dart:io';

Future<void> writeLogs(String message) async {
  File file = File('lib/logs/log.txt');
  file.writeAsString(
    "[${DateTime.now().toIso8601String().split('.').first}Z] $message\n",
    mode: FileMode.append,
  );

  print("[${DateTime.now().toIso8601String().split('.').first}Z] $message");
}
