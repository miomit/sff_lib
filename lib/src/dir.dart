import 'dart:io';
import 'package:path/path.dart' show basename;

/// Recursively copying a file with its contents
///
/// If a file with the same name exists, no copying will be performed.
Stream<(File, File)> copyDirRec(Directory dirIn, Directory dirOut) async* {
  if (!dirOut.existsSync()) {
    dirOut.createSync();
  }

  await for (final entitie in dirIn.list()) {
    if (entitie.statSync().type == FileSystemEntityType.file) {
      if (!File("${dirOut.path}/${entitie.uri.pathSegments.last}").existsSync()) {
        final file = File(entitie.path);
        final fileCopy = file.copySync("${dirOut.path}/${entitie.uri.pathSegments.last}");
        yield (file, fileCopy);
      }
    }
    else if (entitie.statSync().type == FileSystemEntityType.directory) {
      final stream = copyDirRec(
        Directory("${dirIn.path}/${basename(entitie.path)}"),
        Directory("${dirOut.path}/${basename(entitie.path)}")
      );

      await for (final log in stream) {
        yield log;
      }
    }
  }
}

/// recursively copies the contents from the first directory 
/// to another, and then in the same way but on the reverse
Stream<(File, File)> syncDir(Directory dir1, Directory dir2) async* {
  await for (final log in copyDirRec(dir1, dir2)) {
    yield log;
  }

  await for (final log in copyDirRec(dir2, dir1)) {
    yield log;
  }
}