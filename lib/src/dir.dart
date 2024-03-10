import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:sff_lib/sff_lib.dart';

/// Recursively copying a file with its contents
///
/// If a file with the same name exists, no copying will be performed.
Stream<(File, File)> copyDirRec(Directory dirIn, Directory dirOut, [bool isCopyFile = true]) async* {
  if (!dirOut.existsSync()) {
    dirOut.createSync();
  }

  await for (final entitie in dirIn.list()) {
    if (isCopyFile && entitie.statSync().type == FileSystemEntityType.file) {
      if (!File("${dirOut.path}/${entitie.uri.pathSegments.last}").existsSync()) {
        final file = File(entitie.path);
        final fileCopy = file.copySync("${dirOut.path}/${entitie.uri.pathSegments.last}");
        yield (file, fileCopy);
      }
    }
    else if (entitie.statSync().type == FileSystemEntityType.directory) {
      yield* copyDirRec(
        Directory("${dirIn.path}/${basename(entitie.path)}"),
        Directory("${dirOut.path}/${basename(entitie.path)}"),
        isCopyFile,
      );
    }
  }
}

/// Recursively copying a file with its contents, and deletes the copied content.
///
/// Warning: the first argument [File] returned is a deleted file.
Stream<(File, File)>
moveDir(Directory dir1, Directory dir2) async* {
  await for (final (fileOrg, fileCopy) in copyDirRec(dir1, dir2)) {
    fileOrg.deleteSync();
    yield (fileOrg, fileCopy);
  }
}

/// recursively copies the contents from the first directory 
/// to another, and then in the same way but on the reverse
Stream<(File, File)> syncDir(Directory dir1, Directory dir2) async* {
  yield* copyDirRec(dir1, dir2);
  yield* copyDirRec(dir2, dir1);
}