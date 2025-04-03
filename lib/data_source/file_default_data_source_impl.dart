import 'dart:io';

abstract class FileDefaultDataSource {
  Future<void> createFile(String path) async {
    await File(path).create(recursive: true);
  }

  Future<bool> isFileExist(String path) async {
    final File newFile = File(path);
    return await newFile.exists();
  }

  Future<String> getFile(String path) async {
    return File(path).readAsString();
  }

  Future<void> writeFile(String path, String contents, {FileMode? mode}) async {
    await File(path).writeAsString(contents, mode: mode ?? FileMode.write);
  }
}
