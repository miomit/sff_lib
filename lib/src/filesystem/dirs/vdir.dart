part of '../virtual.dart';

class VDir extends Dir {
  List<FSEntity>? children;

  VDir({
    this.children,
  });

  @override
  // TODO: implement stat
  Future<Stat> get stat => throw UnimplementedError();

  @override
  // TODO: implement statSync
  Stat get statSync => throw UnimplementedError();
}
