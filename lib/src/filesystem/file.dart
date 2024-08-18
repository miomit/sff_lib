import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';

class File extends Entity {
  File(String path, {Disk? io}) : super(path, type: EntityType.file, io: io);

  void create({bool recursive = false}) {
    io.create(path, recursive: recursive);
  }

  File copy(String path) => io.copy(super.path, path);

  Stream<List<int>> openRead() => io.openRead(path);

  /// Comparing two files for content equality.
  Future<bool> compareWith(
    File file,
  ) async {
    // TODO relativePath -> uri
    final rPath1 = stat().relativePath;
    final rPath2 = file.stat().relativePath;
    if (rPath1 is String && rPath2 is String && equals(rPath1, rPath2)) {
      return true;
    }
    return (await file.generateHash()) == (await generateHash());
  }

  /// Method that generates a hash code from the contents of a file.
  Future<Digest> generateHash({
    Hash hashMethod = sha1,
  }) async {
    var output = AccumulatorSink<Digest>();
    var input = hashMethod.startChunkedConversion(output);

    await for (final val in openRead()) {
      input.add(val);
    }

    input.close();
    return output.events.single;
  }
}
