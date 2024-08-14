import 'package:sff_lib/filesystem.dart';

class Native implements IFileSystem {
  @override
  void connect() {}

  @override
  void disconnect() {}

  @override
  Entity? open(String path) {
    // TODO: implement open
    throw UnimplementedError();
  }

  @override
  void create(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  }) {
    // TODO: implement create
  }

  @override
  Entity copy(String filePath, String dirPath) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Entity move(String pathIn, String pathOut) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  bool delete(String path, {bool recursive = false}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Stream<Entity> list(String dirPath) {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Stream<int> openRead(String filePath) {
    // TODO: implement openRead
    throw UnimplementedError();
  }

  @override
  Stat stat(String path) {
    // TODO: implement stat
    throw UnimplementedError();
  }
}
