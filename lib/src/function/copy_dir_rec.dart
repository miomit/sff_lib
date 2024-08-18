import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/log.dart';

/// Recursively copying a file with its contents.
///
/// If a file with the same name exists, copying will not be executed.
///
/// If isCopyFile is false, so copies only tree directorias without file.
///
/// Function filter takes the file path and returned bool type.
Stream<Log> copyDirRec(
  Dir dirIn,
  Dir dirOut, {
  bool isCopyFile = true,
  bool Function(String)? filter,
}) async* {
  if (!dirOut.exists()) {
    dirOut.create(recursive: true);
  }

  await for (final entitie in dirIn.list()) {
    if (isCopyFile && entitie is File) {
      final fileIn = entitie;
      final fileOut = File(join(dirOut.path, basename(entitie.path)));
      if (!fileOut.exists()) {
        if (filter != null && !filter(entitie.path)) continue;
        fileIn.copy(fileOut.path);
        // TODO yield F2DLog
      }
    } else if (entitie is Dir) {
      yield* copyDirRec(
        Dir(join(dirIn.path, basename(entitie.path))),
        Dir(join(dirOut.path, basename(entitie.path))),
        isCopyFile: isCopyFile,
        filter: filter,
      );
    }
  }
}
