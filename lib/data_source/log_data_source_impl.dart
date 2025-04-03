import 'dart:io';

import 'package:todo_app/data_source/file_default_data_source_impl.dart';
import 'package:todo_app/data_source/log_data_source.dart';

class LogDataSourceImpl extends FileDefaultDataSource implements LogDataSource {
  static const String logPath = 'lib/data/log.txt';

  @override
  Future<String> readLog() async {
    final contents = await getFile(logPath);
    return contents;
  }

  @override
  Future<void> writeLog(String contents) async {
    if (!(await isFileExist(logPath))) {
      await createFile(logPath);
    }
    await writeFile(logPath, contents, mode: FileMode.append);
  }
}
