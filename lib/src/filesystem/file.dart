import 'package:sff_lib/filesystem.dart';

class File extends Entity {
  File(String path, {Disk? io}) : super(path, type: EntityType.file, io: io);

  File copy(String path) => io.copy(super.path, path);

  Stream<List<int>> openRead() => io.openRead(path);
}
