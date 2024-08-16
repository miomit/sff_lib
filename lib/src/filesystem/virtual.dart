import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';

class VEntity {
  final String name;
  final DateTime created;
  VEntity(this.name) : created = DateTime.now();
}

class VDir extends VEntity {
  final Map<String, VEntity> children;

  int get size {
    int size = 0;
    for (final child in children.values) {
      if (child case VFile file) {
        size += file.data.length;
      } else if (child case VDir dir) {
        size += dir.size;
      }
    }
    return size;
  }

  int get count {
    int count = 0;
    for (final child in children.values) {
      if (child is File) {
        count += 1;
      } else if (child case VDir dir) {
        count += dir.count;
      }
    }
    return count;
  }

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

  VFile.clone(VFile file)
      : changed = file.changed,
        data = file.data.toList(),
        super(file.name);
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

  VEntity? open(
    String path, {
    EntityType type = EntityType.file,
  }) {
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

    if (type == EntityType.file && entity is VFile ||
        type == EntityType.dir && entity is VDir) {
      return entity;
    }

    return null;
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
  void delete(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  }) {
    if (open(dirname(path)) case VDir dir) {
      dir.children.remove(basename(path)) != null ? true : false;
    } else {
      throw "[Virtual FileSystem]: dir not exists!";
    }
  }

  @override
  bool exists(
    String path, {
    EntityType type = EntityType.file,
  }) =>
      open(path, type: type) != null ? true : false;

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
  Stat stat(
    String path, {
    EntityType type = EntityType.file,
  }) {
    if (type == EntityType.file) {
      if (open(path) case VFile file) {
        return FileStat(
          path: path,
          type: type,
          size: file.data.length,
          created: file.created,
          changed: file.changed,
        );
      } else {
        throw "[Virtual filesystem] file not exists!";
      }
    } else if (type == EntityType.dir) {
      if (open(path) case VDir dir) {
        return DirStat(
          path: path,
          type: type,
          size: dir.size,
          created: dir.created,
          count: Future.value(dir.count),
        );
      } else {
        throw "[Virtual filesystem] dir not exists!";
      }
    }
    throw "[Virtual filesystem] unsupported format!";
  }

  static File copyVirtualToVirtual({
    required String filePathIn,
    required String dirPathOut,
    required Virtual fsIn,
    required Virtual fsOut,
  }) {
    final file = fsIn.open(filePathIn)! as VFile;
    final dir = fsOut.open(dirPathOut)! as VDir;

    if (dir.children[file.name] == null) {
      dir.children[file.name] = VFile.clone(file);
    } else {
      throw "[Virtual FileSystem]: file or dir with also name exists!";
    }

    return File(join(dirPathOut, file.name));
  }
}
