part of '../native.dart';

class NFile extends File {
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
  Stream<List<int>> openRead() {
    // TODO: implement openRead
    throw UnimplementedError();
  }
}
