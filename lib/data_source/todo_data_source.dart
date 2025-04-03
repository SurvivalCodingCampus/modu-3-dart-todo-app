abstract interface class TodoDataSource {
  Future<void> writeTodo(List<Map<String, dynamic>> todos);
  Future<List<Map<String, dynamic>>> readTodo();
}
