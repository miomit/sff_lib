import 'dart:io';
import 'package:async/async.dart' show StreamGroup;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart' show AccumulatorSink;
import 'package:sff_lib/sff_lib.dart' show FileLog, Action;

/// Comparing two files for content equality.
Future<bool> compareFilesEquality(
  File file1,
  File file2,
) async {
  return (await generateHashFile(file1)) == (await generateHashFile(file2));
}

/// Stream the channel that transmits (FileLog),
/// where the first is the original file and second is a duplicate.
///
/// For multiple directory searches,
/// the [Directory] list is passed in the parameters.
///
/// Function filter takes the file path and returned bool type.
Stream<FileLog> findDuplicates(
  List<Directory> dirs, {
  File? file,
  bool Function(String)? filter,
}) async* {
  if (dirs.isEmpty) return;
  Map<Digest, File> files = {};

  if (file != null) {
    files[await generateHashFile(file)] = file;
  }
  await for (final entitieFile
      in StreamGroup.merge([for (final dir in dirs) recListFile(dir)])) {
    if (file != null && file.path == entitieFile.path) continue;
    if (filter != null && !filter(entitieFile.path)) continue;

    var hash = await generateHashFile(entitieFile);

    if (files[hash] != null) {
      yield FileLog(
        file1: files[hash]!,
        file2: entitieFile,
        action: Action.compare,
      );
    } else {
      if (file == null) {
        files[hash] = entitieFile;
      }
    }
  }
}

/// Recursively browses the contents of a directory and returns type [File].
///
/// If there are not enough permissions to view the directory,
/// then the directory is skipped.
///
/// This method solves problem of closing stream during recursive traversal
/// (https://github.com/dart-lang/sdk/issues/54803).
///
/// exmaple:
/// ```
/// dir
///   - subDir1
///      - file_b
///      - file_c
///   - subDir2
///   - rootDir <- PathAccessException: Directory listing failed, path = 'dir/rootDir' (OS Error: Permission denied, errno = 13)
///   - file2
///   - file2
/// ```
///
/// `dir.list(recursive: ture)` - closes the stream with an error PathAccessException.
/// `recListFile(dir)` - skips content in derictory dir/rootDir to avoid closing the stream.
Stream<File> recListFile(
  Directory dir,
) async* {
  try {
    await for (final entitie in dir.list()) {
      switch (entitie.statSync().type) {
        case FileSystemEntityType.file:
          yield File(entitie.path);
          break;
        case FileSystemEntityType.directory:
          yield* recListFile(Directory(entitie.path));
          break;
        default:
          break;
      }
    }
  } on PathAccessException {
    print("Insufficient permissions to read subdirectories :( (${dir.path})");
  }
}

/// Method that generates a hash code from the contents of a file.
Future<Digest> generateHashFile(
  File file, [
  Hash hashMethod = sha1,
]) async {
  var output = AccumulatorSink<Digest>();
  var input = hashMethod.startChunkedConversion(output);

  await for (final val in file.openRead()) {
    input.add(val);
  }

  input.close();
  return output.events.single;
}
