abstract interface class TodoDataSource {
  Future<List<Map<String, dynamic>>> readTodos();
  Future<void> writeTodo(Map<String, dynamic> todo);
}
