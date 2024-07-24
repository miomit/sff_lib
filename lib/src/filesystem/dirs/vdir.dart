part of '../virtual.dart';

class VDir extends Dir {
  String name;
  List<FSEntity>? _children;

  VDir({
    required this.name,
    List<FSEntity>? children,
  }) {
    _children = children;
  }

  FSEntity? getChildByName() => throw UnimplementedError();

  @override
  // TODO: implement stat
  Future<Stat> get stat => throw UnimplementedError();

  @override
  // TODO: implement statSync
  Stat get statSync => throw UnimplementedError();
}
