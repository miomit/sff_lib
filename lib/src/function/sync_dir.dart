import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/function.dart';
import 'package:sff_lib/log.dart';

/// Recursively copies the contents from the first directory
/// to another, and then in the same way but on the reverse.
///
/// If isCopyFile is false, so copies only tree directorias without file.
///
/// Function filter takes the file path and returned bool type.
Stream<Log> syncDir(
  Dir dir1,
  Dir dir2, {
  bool isCopyFile = true,
  bool Function(String)? filter,
}) async* {
  yield* copyDirRec(
    dir1,
    dir2,
    isCopyFile: isCopyFile,
    filter: filter,
  );
  yield* copyDirRec(
    dir2,
    dir1,
    isCopyFile: isCopyFile,
    filter: filter,
  );
}
