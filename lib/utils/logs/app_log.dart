import 'dart:io';
import 'package:todo_app/utils/logs/logger.dart';

class AppLog implements Logger {
  final String filePath;

  AppLog({this.filePath = 'logs/log.txt'});

  @override
  Future<void> log(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] $message\n';

    final file = File(filePath);

    // 파일 경로가 없으면 자동으로 생성
    if (!await file.exists()) {
      await file.create(recursive: true); // 경로가 없다면 폴더 포함하여 생성
    }

    await file.writeAsString(logMessage, mode: FileMode.append);
  }
}
