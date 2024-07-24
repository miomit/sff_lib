part of '../virtual.dart';

class VDir extends Dir {
  String _name;
  List<FSEntity>? _children;

  VDir({
    required String name,
    List<FSEntity>? children,
  })  : _name = name,
        _children = children;

  FSEntity? getChildByName(String name) {
    if (_children != null) {
      for (var child in _children!) {
        if (child.name == name) {
          return child;
        }
      }
    }
    return null;
  }

  void addChild(FSEntity child) {
    if (getChildByName(child.name) == null) {
      _children!.add(child);
    } else {
      throw "A child by that name exists";
    }
  }

  @override
  String get name => _name;

  @override
  Future<Stat> get stat => Future.value(statSync);

  @override
  Stat get statSync {
    int size = 0;

    if (_children != null) {
      for (var child in _children!) {
        size += child.statSync.size;
      }
    }

    return Stat(
      name: name,
      size: size,
      type: FSType.dir,
    );
  }
}
