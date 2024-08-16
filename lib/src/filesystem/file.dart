import 'package:sff_lib/filesystem.dart';

class File extends Entity {
  File(String path) : super(path, type: EntityType.file);

  File copy(String path) => io.copy(super.path, path) as File;

  Stream<List<int>> openRead() => io.openRead(path);
}
