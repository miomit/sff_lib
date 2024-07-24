part of '../native.dart';

class NDir extends Dir {
  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement stat
  Future<Stat> get stat => throw UnimplementedError();

  @override
  // TODO: implement statSync
  Stat get statSync => throw UnimplementedError();

  @override
  Stream<FSEntity> list({
    bool recursive = false,
    void Function(Exception e, FSEntity fse)? onException,
  }) {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<Dir?> mkdir(String name) {
    // TODO: implement mkdir
    throw UnimplementedError();
  }

  @override
  Dir? mkdirSync(String name) {
    // TODO: implement mkdirSync
    throw UnimplementedError();
  }

  @override
  Future<File?> touch(String name) {
    // TODO: implement touch
    throw UnimplementedError();
  }

  @override
  File? touchSync(String name) {
    // TODO: implement touchSync
    throw UnimplementedError();
  }
}
