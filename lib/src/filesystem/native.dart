import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/src/filesystem/stat.dart';

class Native implements IFileSystem {
  final io.Directory root;

  Native(String path) : root = io.Directory(path);

  @override
  void connect() {
    if (!root.existsSync()) {
      root.createSync();
    }
  }

  @override
  void disconnect() {}

  @override
  void create(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  }) {
    final nPath = join(root.path, path);
    return switch (type) {
      EntityType.file => io.File(nPath).createSync(recursive: recursive),
      EntityType.dir => io.Directory(nPath).createSync(recursive: recursive),
    };
  }

  @override
  void delete(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  }) {
    final nPath = join(root.path, path);
    return switch (type) {
      EntityType.file => io.File(nPath).deleteSync(recursive: recursive),
      EntityType.dir => io.Directory(nPath).deleteSync(recursive: recursive),
    };
  }

  @override
  bool exists(
    String path, {
    EntityType type = EntityType.file,
  }) {
    final nPath = join(root.path, path);
    return switch (type) {
      EntityType.file => io.File(nPath).existsSync(),
      EntityType.dir => io.Directory(nPath).existsSync(),
    };
  }

  @override
  Stream<Entity> list(String dirPath) async* {
    final nPath = join(root.path, dirPath);
    await for (final entity in io.Directory(nPath).list()) {
      final rPath = relative(entity.path, from: root.path);
      yield switch (entity.statSync().type) {
        io.FileSystemEntityType.file => File(rPath),
        io.FileSystemEntityType.directory => Dir(rPath),
        _ => throw "[Native filesystem] unsupported format!",
      };
    }
  }

  @override
  Stream<List<int>> openRead(String filePath) {
    final nPath = join(root.path, filePath);
    return io.File(nPath).openRead();
  }

  @override
  Stat stat(
    String path, {
    EntityType type = EntityType.file,
  }) {
    final nPath = join(root.path, path);
    if (type == EntityType.file) {
      io.FileStat stat = io.File(nPath).statSync();
      return FileStat(
        path: path,
        relativePath: nPath,
        type: type,
        size: stat.size,
        created: stat.modified,
        changed: stat.changed,
      );
    } else if (type == EntityType.dir) {
      io.FileStat stat = io.Directory(nPath).statSync();
      return DirStat(
        path: path,
        relativePath: nPath,
        type: type,
        size: stat.size,
        created: stat.modified,
        count: Future.sync(() async {
          int count = 0;
          await for (final entity in io.Directory(nPath).list(
            recursive: true,
          )) {
            if (entity is io.File) {
              count++;
            }
          }
          return count;
        }),
      );
    }
    throw "[Native filesystem] unsupported format!";
  }

  static File copyNativeToNative({
    required String pathIn,
    required String pathOut,
    required Native fsIn,
    required Native fsOut,
  }) {
    final nPathIn = join(fsIn.root.path, pathIn);
    final nPathOut = join(fsOut.root.path, pathOut);
    io.File(nPathIn).copySync(nPathOut);

    return File(pathOut);
  }
}
