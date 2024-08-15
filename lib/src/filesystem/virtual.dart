import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';

class VEntity {
  final String name;
  final DateTime created;
  VEntity(this.name) : created = DateTime.now();
}

class VDir extends VEntity {
  final Map<String, VEntity> children;

  VDir(
    super.name, {
    Map<String, VEntity>? children,
  }) : children = children ?? {};

  VDir.root() : this("");
}

class VFile extends VEntity {
  DateTime changed;
  List<int> data;
  VFile(
    super.name, {
    List<int>? data,
  })  : changed = DateTime.now(),
        data = data ?? [];
}

class Virtual implements IFileSystem {
  final VDir root = VDir.root();

  @override
  void connect() {
    print("[Virtual FileSystem] connected");
  }

  @override
  void disconnect() {
    print("[Virtual FileSystem] disconnected");
  }

  VEntity? open(String path) {
    VEntity entity = root;

    for (final name in split(path)) {
      if (entity case VDir dir) {
        if (dir.children[name] != null) {
          entity = dir.children[name]!;
          continue;
        }
      }
      return null;
    }

    return entity;
  }

  @override
  void create(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  }) {
    final [...dirNames, entityName] = split(path);
    VEntity entity = root;
    for (final dirName in dirNames) {
      if (entity case VDir dir) {
        if (dir.children[dirName] != null) {
          entity = dir.children[dirName]!;
          continue;
        } else if (recursive) {
          dir.children[dirName] = entity = VDir(dirName);
          continue;
        }
      }
      return;
    }

    if (entity case VDir dir) {
      if (dir.children[entityName] == null) {
        dir.children[entityName] = switch (type) {
          EntityType.file => VFile(entityName),
          EntityType.dir => VDir(entityName)
        };
      } else {
        throw "[Virtual FileSystem]: file or dir with also name exists!";
      }
    }
  }

  @override
  Entity copy(String filePath, String dirPath) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Entity move(String pathIn, String pathOut) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  bool delete(String path, {bool recursive = false}) {
    if (open(dirname(path)) case VDir dir) {
      return dir.children.remove(basename(path)) != null ? true : false;
    }

    return false;
  }

  @override
  Stream<Entity> list(String dirPath) async* {
    if (open(dirPath) case VDir dir) {
      for (final child in dir.children.values) {
        yield switch (child) {
          VDir(name: String name) => Dir("$dirPath\\$name"),
          VFile(name: String name) => File("dirPath\\$name"),
          VEntity() => throw UnimplementedError(),
        };
      }
    }
  }

  @override
  Stream<List<int>> openRead(String filePath) async* {
    if (open(filePath) case VFile file) {
      for (int i = 0; i < file.data.length; i += 250) {
        yield file.data.sublist(i, i + 250);
      }
    }
  }

  @override
  Stat stat(String path) {
    // TODO: implement stat
    throw UnimplementedError();
  }
}
