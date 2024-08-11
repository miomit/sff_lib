import 'package:sff_lib/services.dart';

class NativeFilesystemService implements IFilesystemService {
  @override
  bool connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  FileService copy(String pathIn, String pathOut) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  bool delete(String path, {bool recursive = false}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  bool disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  FilesystemEntityTypeService getType(String path) {
    // TODO: implement getType
    throw UnimplementedError();
  }

  @override
  Stream<FilesystemEntityService> list(String path) {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  DirService mkdir(String path, {bool recursive = false}) {
    // TODO: implement mkdir
    throw UnimplementedError();
  }

  @override
  FilesystemEntityService move(String pathIn, String pathOut) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  FilesystemEntityService? open(String path) {
    // TODO: implement open
    throw UnimplementedError();
  }

  @override
  Stream<List<int>> openRead(String path) {
    // TODO: implement openRead
    throw UnimplementedError();
  }

  @override
  // TODO: implement rootPath
  String get rootPath => throw UnimplementedError();

  @override
  StatService stat(String path) {
    // TODO: implement stat
    throw UnimplementedError();
  }

  @override
  FileService touch(String path, {bool recursive = false}) {
    // TODO: implement touch
    throw UnimplementedError();
  }
}
