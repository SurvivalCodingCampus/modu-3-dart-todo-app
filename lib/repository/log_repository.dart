abstract interface class LogRepository {
  Future<void> saveLog(String log);

  Future<String> readLog();
}
