import 'dart:io';

import 'package:todo_app/data_source/todo_data_source_impl.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/todo_repository.dart';
import 'package:todo_app/repository/todo_repository_impl.dart';

class TodoView {
  void listView(List<Todo> todos) {
    print('[할 일 목록]');
    for (int i = 0; i < todos.length; i++) {
      print(
        '${i + 1}. [${todos[i].completed ? 'X' : ' '}] ${todos[i].title}(${todos[i].createdAt})',
      );
    }
    print('--------------------------------------------------');
  }

  void addView() {
    print('[할 일 제목을 입력하세요.]');
    final titleInput = stdin.readLineSync();

    print('--------------------------------------------------');
  }
}
