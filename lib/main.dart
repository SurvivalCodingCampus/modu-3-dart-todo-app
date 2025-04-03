import 'dart:io';

import 'package:todo_app/log_service.dart';
import 'package:todo_app/view/todo_view.dart';

void main() async {
  final LogService logFile = LogService('${Directory.current.path}/log.txt');
  try {
    bool isFlag = true;

    await logFile.log('앱 시작됨');

    while (isFlag) {
      printMenu();

      String? userInput = stdin.readLineSync();

      switch (userInput) {
        case '1':
          await TodoView().listView(logFile);
          break;
        case '2':
          await TodoView().addView(logFile);
          break;
        case '3':
          await TodoView().updateView(logFile);
          break;
        case '4':
          await TodoView().toggleView(logFile);
          break;
        case '5':
          await TodoView().deleteView(logFile);
          break;
        case '0':
          print('종료');
          isFlag = false;
          break;
        default:
          throw ('올바른 메뉴 버튼을 입력해주세요');
      }
    }
  } catch (e) {
    await logFile.log('예외발생: $e');
  }
}

void printMenu() {
  print('┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓');
  print('|          📝 TO-DO LIST          |');
  print('┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛');
  print('\n  번호/항목 \n');
  print('   1️⃣  👀 목록 보기        \n');
  print('   2️⃣  ➕ 할 일 추가       \n');
  print('   3️⃣  ✏️  할 일 수정       \n');
  print('   4️⃣  ✅ 완료 상태 체크    \n');
  print('   5️⃣  🗑️  할 일 삭제       \n');
  print('   0️⃣  🚪 종료            \n');

  print('==================================');
  stdout.write('💡원하는 메뉴(번호)를 입력하세요 ➡️   ');
}
