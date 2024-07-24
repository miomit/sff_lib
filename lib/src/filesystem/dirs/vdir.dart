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

  @override
  Stream<FSEntity> list({
    bool recursive = false,
    void Function(Exception e, FSEntity fse)? onException,
  }) async* {
    if (_children != null) {
      for (var child in _children!) {
        try {
          if (!recursive) {
            yield child;
          } else if (child case Dir dir) {
            yield* dir.list();
          } else {
            yield child;
          }
        } on Exception catch (e) {
          if (onException != null) {
            onException(e, child);
          } else {
            rethrow;
          }
        } catch (_) {
          rethrow;
        }
      }
    }
  }

  @override
  Future<Dir?> mkdir(String name) => Future.value(mkdirSync(name));

  @override
  Dir? mkdirSync(String name) {
    if (getChildByName(name) == null) {
      var dir = VDir(name: name);
      addChild(dir);
      return dir;
    }
    return null;
  }

  @override
  Future<File?> touch(String name) => Future.value(touchSync(name));

  @override
  File? touchSync(String name) {
    if (getChildByName(name) == null) {
      var file = VFile(name: name);
      addChild(file);
      return file;
    }
    return null;
  }
}
