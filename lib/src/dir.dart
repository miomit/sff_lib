import 'dart:io';
import 'package:path/path.dart' show basename;

/// Recursively copying a file with its contents
///
/// If a file with the same name exists, no copying will be performed.
Future<void> copyDirRec(Directory dirIn, Directory dirOut) async {
  if (!dirOut.existsSync()) {
    dirOut.createSync();
  }

  await for (final entitie in dirIn.list()) {
    if (entitie.statSync().type == FileSystemEntityType.file) {
      if (!File("${dirOut.path}/${entitie.uri.pathSegments.last}").existsSync()) {
        File(entitie.path).copySync("${dirOut.path}/${entitie.uri.pathSegments.last}");
      }
    }
    else if (entitie.statSync().type == FileSystemEntityType.directory) {
      await copyDirRec(
        Directory("${dirIn.path}/${basename(entitie.path)}"),
        Directory("${dirOut.path}/${basename(entitie.path)}")
      );
    }
  }
}

/// recursively copies the contents from the first directory 
/// to another, and then in the same way but on the reverse
void syncDir(Directory dir1, Directory dir2) async {
  await copyDirRec(
    dir1,
    dir2
  );

  await copyDirRec(
    dir2,
    dir1
  );
}