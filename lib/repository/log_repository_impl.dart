import 'package:todo_app/data_source/log_data_source.dart';
import 'package:todo_app/repository/log_repository.dart';

class LogRepositoryImpl implements LogRepository {
  final LogDataSource _logDataSource;

  LogRepositoryImpl({required LogDataSource logDataSource})
    : _logDataSource = logDataSource;

  @override
  Future<String> readLog() async {
    return _logDataSource.readLog();
  }

  @override
  Future<void> saveLog(String log) async {
    await _logDataSource.writeLog(log);
  }
}
