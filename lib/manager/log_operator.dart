import 'package:intl/intl.dart';
import 'package:todo_app/repository/log_repository.dart';

class LogOperator {
  final LogRepository _logRepository;

  LogOperator(this._logRepository);

  Future<void> log(String message) async {
    String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await _logRepository.saveLog('[$now] $message\n');
  }
}
