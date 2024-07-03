import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:sff_lib/sff_lib.dart' show FileLog, Action;

/// Recursively copying a file with its contents
///
/// If a file with the same name exists, no copying will be performed.
Stream<FileLog> copyDirRec(
  Directory dirIn,
  Directory dirOut, {
  bool isCopyFile = true,
  bool Function(String)? filter,
}) async* {
  if (!dirOut.existsSync()) {
    dirOut.createSync();
  }

  await for (final entitie in dirIn.list()) {
    if (isCopyFile && entitie.statSync().type == FileSystemEntityType.file) {
      if (!File("${dirOut.path}/${entitie.uri.pathSegments.last}")
          .existsSync()) {
        if (filter != null && !filter(entitie.path)) continue;
        final file = File(entitie.path);
        final fileCopy =
            file.copySync("${dirOut.path}/${entitie.uri.pathSegments.last}");
        yield FileLog(
          file1: file,
          file2: fileCopy,
          action: Action.copy,
        );
      }
    } else if (entitie.statSync().type == FileSystemEntityType.directory) {
      yield* copyDirRec(
        Directory("${dirIn.path}/${basename(entitie.path)}"),
        Directory("${dirOut.path}/${basename(entitie.path)}"),
        isCopyFile: isCopyFile,
        filter: filter,
      );
    }
  }
}

/// Recursively copying a file with its contents, and deletes the copied content.
///
/// Warning: the first argument [File] returned is a deleted file.
Stream<FileLog> moveDir(
  Directory dir1,
  Directory dir2,
) async* {
  await for (final fl in copyDirRec(dir1, dir2)) {
    fl.file1.deleteSync();
    fl.action = Action.move;
    yield fl;
  }
}

/// recursively copies the contents from the first directory
/// to another, and then in the same way but on the reverse
Stream<FileLog> syncDir(
  Directory dir1,
  Directory dir2, {
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
