import 'package:sff_lib/filesystem.dart';

class Dir extends Entity {
  Dir(String path) : super(path, type: EntityType.dir);

  Stream<Entity> list({bool recursive = false}) async* {
    await for (final entity in io.list(path)) {
      yield entity;
      if (recursive && entity is Dir) {
        yield* entity.list(recursive: true);
      }
    }
  }
}
