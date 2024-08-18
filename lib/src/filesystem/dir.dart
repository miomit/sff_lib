import 'package:sff_lib/filesystem.dart';

class Dir extends Entity {
  Dir(String path, {Disk? io}) : super(path, type: EntityType.dir, io: io);

  void create({bool recursive = false}) {
    io.create(path, recursive: recursive, type: EntityType.dir);
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
