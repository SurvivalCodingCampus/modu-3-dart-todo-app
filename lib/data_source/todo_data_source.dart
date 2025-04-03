abstract interface class TodoDataSource {
  Future<List<Map<String, dynamic>>> readTodos();
  Future<void> writeTodos(List<Map<String, dynamic>> todos);
}
