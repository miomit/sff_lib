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
}
