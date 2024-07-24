part of '../virtual.dart';

class VDir extends Dir {
  String _name;
  List<FSEntity>? _children;

  VDir({
    required String name,
    List<FSEntity>? children,
  })  : _name = name,
        _children = children;

  FSEntity? getChildByName() => throw UnimplementedError();

  @override
  String get name => _name;

  @override
  // TODO: implement stat
  Future<Stat> get stat => throw UnimplementedError();

  @override
  // TODO: implement statSync
  Stat get statSync => throw UnimplementedError();
}
