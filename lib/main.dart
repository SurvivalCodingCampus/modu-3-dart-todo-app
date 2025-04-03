import 'package:todo_app/repository/todo_repository_impl.dart';
import 'package:todo_app/utils/cli_utils/cli_utils.dart';
import 'package:todo_app/utils/logs/app_log.dart';
import 'package:todo_app/utils/logs/logger.dart';
import 'data_source/todo_data_source_impl.dart';

void main() async {
  final cliUtils = CliUtils(logger: AppLog(),
    repository: TodoRepositoryImpl(
      datasource: TodoDataSourceImpl(path: 'data/todos.json'),
    ),
  );

  await cliUtils.processCommand();
}
