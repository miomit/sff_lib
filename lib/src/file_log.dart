import 'package:sff_lib/src/file_details.dart';

/// Enumerating all kinds of actions on files.
enum Action {
  copy,
  move,
  rename,
  delete,
  compare,
}

/// Сlass for saving the result of file operations
class FileLog {
  FileDetails file1;
  FileDetails? file2;

  Action action;

  Error? error;

  FileLog({
    required this.file1,
    required this.action,
    this.file2,
    this.error,
  });

  @override
  String toString() {
    var res = "";

    if (error != null) {
      res += "[Error]: $error\n";
    }

    res += "[File1]: ${file1.path}\n";

    if (file2 != null) {
      res += "[File2]: ${file2!.path}\n";
    }

    res += "[Action]: ${action.name}";

    return res;
  }
}
