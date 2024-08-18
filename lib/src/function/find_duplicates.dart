import 'package:async/async.dart';
import 'package:crypto/crypto.dart';
import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/log.dart';

/// Stream the channel that transmits (FileLog),
/// where the first is the original file and second is a duplicate.
///
/// For multiple directory searches,
/// the [Directory] list is passed in the parameters.
///
/// Function filter takes the file path and returned bool type.
Stream<Log> findDuplicates(
  List<Dir> dirs, {
  File? file,
  bool Function(File)? filter,
}) async* {
  if (dirs.isEmpty) return;
  Map<Digest, File> files = {};

  if (file != null) {
    files[await file.generateHash()] = file;
  }
  await for (final entitie in StreamGroup.merge(
    [
      for (final dir in dirs) dir.list(recursive: true),
    ],
  )) {
    if (entitie is File) {
      if (file != null && await file.compareWith(entitie)) {
        continue;
      }
      if (filter != null && !filter(entitie)) continue;

      var hash = await entitie.generateHash();

      if (files[hash] != null) {
        // TODO yield F2F log with Action.compare: files[hash]! and entitie
      } else {
        if (file == null) {
          files[hash] = entitie;
        }
      }
    }
  }
}
