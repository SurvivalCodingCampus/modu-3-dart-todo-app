import 'dart:io';
import 'package:todo_app/enum/todo_condition.dart';
import 'package:todo_app/manager/log_operator.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/todo_repository.dart';

import 'action.dart';

sealed class TodoCliManager {
  final TodoRepository todoRepository;
  final LogOperator logOperator;

  const TodoCliManager({
    required this.todoRepository,
    required this.logOperator,
  });

  // 각 command 마다 실행하는 메서드
  Future<Action> execute();

  // 처음 진입 시 실행하는 메서드
  static start() {
    _showMenu();
  }

  // 초기화면에서 입력 받은 값을 TodoCliManager로 생성하고 실행
  static Future<Action> executeFromInput(
    String? value,
    TodoRepository todoRepository,
    LogOperator logOperator,
  ) async {
    final action = fromInput(value, todoRepository, logOperator);
    return action.execute();
  }

  // 초기화면에서 입력 받은 값을 TodoCliManager로 생성
  static TodoCliManager fromInput(
    String? value,
    TodoRepository todoRepository,
    LogOperator logOperator,
  ) {
    final command = int.tryParse(value ?? '-1');
    return switch (command) {
      1 => ViewTodosOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      2 => AddTodoOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      3 => UpdateTodoOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      4 => ToggleTodoOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      5 => DeleteTodoOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      0 => ExitOutput(todoRepository: todoRepository, logOperator: logOperator),
      _ => RetryOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
    };
  }

  // 목록 보여주는 옵션 화면에서 입력 받은 값을 TodoCliManager로 생성
  static TodoCliManager displayModeFromInput(
    String? value,
    TodoRepository todoRepository,
    LogOperator logOperator,
  ) {
    final command = int.tryParse(value ?? '-1');
    return switch (command) {
      1 => AscendingOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      2 => DescendingOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      3 => CompletedOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      4 => NotCompletedOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
      _ => RetryOutput(
        todoRepository: todoRepository,
        logOperator: logOperator,
      ),
    };
  }

  // 유저가 입력한 값을 메세지와 함께 출력하는 메서드
  String _getUserInput(String message) {
    print(message);
    return stdin.readLineSync() ?? '';
  }

  // 초기 화면 메뉴 출력
  static void _showMenu() {
    print('''
=== TODO LIST 프로그램 ===
1. 목록 보기
2. 할 일 추가
3. 할 일 수정
4. 완료 상태 토글
5. 할 일 삭제
0. 종료
--------------------------
선택하세요: 
''');
  }

  // 목록 보여주는 옵션 메뉴 출력
  static void _showTodosOptions() {
    print('''
=== 옵션 선택 ===
0: 기본
1: 오름차순
2: 내림차순
3: 완료만
4: 미완료만
------------------
선택하세요: ''');
  }

  // 목록 순서대로 프린트
  void _showTodos(List<Todo> todos, TodoCondition condition) {
    print('[${condition.name} 할 일 목록]');
    for (int i = 0; i < todos.length; i++) {
      print('${i + 1}. ${todos[i].toString()}');
    }
  }
}

// 목록 보기
class ViewTodosOutput extends TodoCliManager {
  const ViewTodosOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    TodoCliManager._showTodosOptions();
    String? command = stdin.readLineSync();
    stdout.flush();
    final result = TodoCliManager.displayModeFromInput(
      command,
      todoRepository,
      logOperator,
    );
    await result.execute();
    return Action.continueAction;
  }
}

// 할 일 추가
class AddTodoOutput extends TodoCliManager {
  const AddTodoOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    String title = _getUserInput('할 일 제목을 입력하세요:');
    await todoRepository.addTodo(title);

    int id = await todoRepository.getLastIndex();
    print('[할 일 추가됨]');
    await logOperator.log('할 일 추가됨 - ID: $id, 제목: \'$title\'');

    return Action.continueAction;
  }
}

// 할 일 수정
class UpdateTodoOutput extends TodoCliManager {
  const UpdateTodoOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    String id = _getUserInput('수정할 할 일 ID를 입력하세요:');
    String title = _getUserInput('새 제목을 입력하세요:');
    await todoRepository.updateTodo(int.parse(id), title);
    print('[할 일 제목이 수정되었습니다]');
    await logOperator.log('할 일 수정 - ID: $id, 제목: \'$title\'');
    return Action.continueAction;
  }
}

// 완료 상태 토글
class ToggleTodoOutput extends TodoCliManager {
  const ToggleTodoOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    String id = _getUserInput('완료 상태를 토글할 할 일 ID를 입력하세요:');
    bool isCompleted = await todoRepository.toggleTodo(int.parse(id));
    print('[할 일 완료 상태가 변경되었습니다]');
    await logOperator.log(
      '할 일 완료 토글 - ID: $id, 상태: ${isCompleted ? '완료됨' : '미완료됨'}',
    );
    return Action.continueAction;
  }
}

// 할 일 삭제
class DeleteTodoOutput extends TodoCliManager {
  const DeleteTodoOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    String id = _getUserInput('삭제할 할 일 ID를 입력하세요:');
    await todoRepository.deleteTodo(int.parse(id));
    print('[할 일이 삭제되었습니다]');
    await logOperator.log('할 일 삭제됨 - ID: $id');
    return Action.continueAction;
  }
}

// 종료
class ExitOutput extends TodoCliManager {
  const ExitOutput({required super.todoRepository, required super.logOperator});

  @override
  Future<Action> execute() async {
    print('[프로그램을 종료합니다. 데이터가 저장되었습니다.]');
    await logOperator.log('앱 종료됨');
    return Action.exit;
  }
}

class RetryOutput extends TodoCliManager {
  const RetryOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    print('[잘못 입력했습니다. 다시 입력해주세요]');
    await logOperator.log('잘못 입력함.');
    return Action.continueAction;
  }
}

// 목록 옵션 - 오름차순
class AscendingOutput extends TodoCliManager {
  static const _condition = TodoCondition.isAscending;

  const AscendingOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    final todos = await todoRepository.getTodos(condition: _condition);
    _showTodos(todos, _condition);
    return Action.continueAction;
  }
}

// 목록 옵션 - 내림차순
class DescendingOutput extends TodoCliManager {
  static const _condition = TodoCondition.isDescending;

  const DescendingOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    final todos = await todoRepository.getTodos(condition: _condition);
    _showTodos(todos, _condition);
    return Action.continueAction;
  }
}

// 목록 옵션 - 완료된 목록
class CompletedOutput extends TodoCliManager {
  static const _condition = TodoCondition.isCompleted;

  const CompletedOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    final todos = await todoRepository.getTodos(condition: _condition);
    _showTodos(todos, _condition);
    return Action.continueAction;
  }
}

// 목록 옵션 - 미 완료된 목록
class NotCompletedOutput extends TodoCliManager {
  static const _condition = TodoCondition.isNotCompleted;

  const NotCompletedOutput({
    required super.todoRepository,
    required super.logOperator,
  });

  @override
  Future<Action> execute() async {
    final todos = await todoRepository.getTodos(condition: _condition);
    _showTodos(todos, _condition);
    return Action.continueAction;
  }
}
