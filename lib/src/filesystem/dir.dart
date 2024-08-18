import 'package:sff_lib/filesystem.dart';

class Dir extends Entity {
  Dir(String path, {Disk? io}) : super(path, type: EntityType.dir, io: io);

  void create({bool recursive = false}) {
    io.create(path, recursive: recursive, type: EntityType.dir);
  }

  Stream<Entity> list({
    bool recursive = false,
    void Function(Exception e, Entity entity)? onException,
  }) async* {
    await for (final entity in io.list(path)) {
      try {
        yield entity;
        if (recursive && entity is Dir) {
          yield* entity.list(recursive: true);
        }
      } on Exception catch (e) {
        if (onException != null) {
          onException(e, entity);
        } else {
          rethrow;
        }
      }
    }
  }
}
