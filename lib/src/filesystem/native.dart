import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/src/filesystem/file.dart';

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
  Entity copy(String filePath, String dirPath) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Entity move(
    String pathIn,
    String pathOut, {
    EntityType type = EntityType.file,
  }) {
    // TODO: implement move
    throw UnimplementedError();
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
    // TODO: implement openRead
    throw UnimplementedError();
  }

  @override
  Stat stat(
    String path, {
    EntityType type = EntityType.file,
  }) {
    // TODO: implement stat
    throw UnimplementedError();
  }
}
