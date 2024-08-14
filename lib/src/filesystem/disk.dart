import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';

class Disk implements IFileSystem {
  static Disk io = Disk();

  final Map<String, IFileSystem> _fileSystems = {};

  List<String> get targets => _fileSystems.keys.toList();

  (IFileSystem?, String?) getFileSystemAndRelativePathByPath(String path) {
    var target = rootPrefix(path);
    if (target != "") {
      var relativePath = relative(path, from: target);
      if (relativePath != "") {
        return (_fileSystems[target], relativePath);
      }
    }
    return (null, null);
  }

  void mount(String target, IFileSystem fs) {
    if (_fileSystems[target] == null) {
      try {
        fs.connect();
      } catch (_) {
        rethrow;
      }
      _fileSystems[target] = fs;
    }
  }

  void unmount(String target) {
    if (_fileSystems[target] != null) {
      try {
        _fileSystems[target]!.disconnect();
      } catch (_) {
        rethrow;
      }
      _fileSystems.remove(target);
    }
  }

  @override
  void connect() {}

  @override
  void disconnect() {}

  @override
  Entity? open(String path) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(path);
    if (fs != null && rPath != null) {
      if (fs.open(rPath) case Entity entity) {
        entity.path = join(rootPrefix(path), entity.path);
        return entity;
      }
    }
    return null;
  }

  @override
  void create(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  }) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(path);
    if (fs != null && rPath != null) {
      return fs.create(rPath, recursive: recursive, type: type);
    }
    throw "[Disk]: FileSystems don't mount.";
  }

  @override
  Entity copy(String filePath, String dirPath) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(filePath);
    if (fs != null && rPath != null) {
      return fs.copy(rPath, dirPath);
    }
    throw "[Disk]: FileSystems don't mount.";
  }

  @override
  Entity move(String pathIn, String pathOut) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(pathIn);
    if (fs != null && rPath != null) {
      return fs.copy(rPath, pathOut);
    }
    throw "[Disk]: FileSystems don't mount.";
  }

  @override
  bool delete(String path, {bool recursive = false}) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(path);
    if (fs != null && rPath != null) {
      return fs.delete(rPath, recursive: recursive);
    }
    throw "[Disk]: FileSystems don't mount.";
  }

  @override
  Stream<Entity> list(String dirPath) async* {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(dirPath);
    if (fs != null && rPath != null) {
      yield* fs.list(rPath);
    }
  }

  @override
  Stream<int> openRead(String filePath) async* {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(filePath);
    if (fs != null && rPath != null) {
      yield* fs.openRead(rPath);
    }
  }

  @override
  Stat stat(String path) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(path);
    if (fs != null && rPath != null) {
      return fs.stat(rPath);
    }
    throw "[Disk]: FileSystems don't mount.";
  }
}
