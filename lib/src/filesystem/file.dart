import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:sff_lib/filesystem.dart';

class File extends Entity {
  File(String path, {Disk? io}) : super(path, type: EntityType.file, io: io);

  void create({bool recursive = false}) {
    io.create(path, recursive: recursive);
  }

  File copy(String path) => io.copy(super.path, path);

  Stream<List<int>> openRead() => io.openRead(path);

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
