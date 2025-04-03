abstract interface class LogDataSource {
  Future<void> writeLog(String contents);
  Future<String> readLog();
}
