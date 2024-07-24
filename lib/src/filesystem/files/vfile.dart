part of '../virtual.dart';

class VFile extends File {
  @override
  // TODO: implement stat
  Future<Stat> get stat => throw UnimplementedError();

  @override
  // TODO: implement statSync
  Stat get statSync => throw UnimplementedError();
}
