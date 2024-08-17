import 'package:path/path.dart';
import 'package:sff_lib/filesystem.dart';
import 'package:sff_lib/log.dart';

class Disk implements IFileSystem {
  static Disk io = Disk();

  final Map<String, IFileSystem> _fileSystems = {};

  List<String> get targets => _fileSystems.keys.toList();

  LogStack logStack;

  Disk({LogStack? logStack}) : logStack = logStack ?? LogStack.global;

  (IFileSystem?, String?) getFileSystemAndRelativePathByPath(String path) {
    var target = rootPrefix(path);
    if (target != "") {
      var relativePath = relative(path, from: target);
      if (relativePath == ".") {
        return (_fileSystems[target], r"\");
      } else {
        return (_fileSystems[target], "\\$relativePath");
      }
    }
    return (null, null);
  }

  void mount(String target, IFileSystem fs) {
    logStack.push(Log.info("[Disk] called mount"));
    if (_fileSystems[target] == null) {
      try {
        fs.connect();
      } catch (_) {
        logStack.push(Log.error("[Disk] file system connection error"));
        rethrow;
      }
      _fileSystems[target] = fs;

      logStack.push(Log.success("[Disk] a $fs with this $target was mounted"));
    } else {
      logStack.push(
        Log.warring(
          "[Disk] a $fs with the same $target already exists",
        ),
      );
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

  File copy(String filePath, String dirPath) {
    var (fsIn, rFilePathIn) = getFileSystemAndRelativePathByPath(filePath);
    var (fsOut, rDirPathOut) = getFileSystemAndRelativePathByPath(dirPath);
    if (fsIn != null && fsOut != null) {
      if (rFilePathIn != null && rDirPathOut != null) {
        File res;
        if (fsIn is Native && fsOut is Native) {
          res = Native.copyNativeToNative(
            pathIn: rFilePathIn,
            pathOut: join(rDirPathOut, basename(rFilePathIn)),
            fsIn: fsIn,
            fsOut: fsOut,
          );
        } else if (fsIn is Virtual && fsOut is Virtual) {
          res = Virtual.copyVirtualToVirtual(
            filePathIn: rFilePathIn,
            dirPathOut: rDirPathOut,
            fsIn: fsIn,
            fsOut: fsOut,
          );
        } else {
          throw "[Disk]: Unsupported copying of these filesystems";
        }

        res.path = join(rootPrefix(dirPath), res.path);
        return res;
      }
    }
    throw "[Disk]: FileSystems don't mount.";
  }

  Entity move(
    String filePath,
    String dirPath, {
    EntityType type = EntityType.file,
  }) {
    var (fsIn, rFilePathIn) = getFileSystemAndRelativePathByPath(filePath);
    var (fsOut, rDirPathOut) = getFileSystemAndRelativePathByPath(dirPath);
    if (fsIn != null && fsOut != null) {
      if (rFilePathIn != null && rDirPathOut != null) {
        Entity res;
        if (fsIn is Native && fsOut is Native) {
          res = Native.moveNativeToNative(
            pathIn: rFilePathIn,
            pathOut: join(rDirPathOut, basename(rFilePathIn)),
            fsIn: fsIn,
            fsOut: fsOut,
            type: type,
          );
        } else if (fsIn is Virtual && fsOut is Virtual) {
          res = Virtual.moveVirtualToVirtual(
            filePathIn: rFilePathIn,
            dirPathOut: rDirPathOut,
            fsIn: fsIn,
            fsOut: fsOut,
            type: type,
          );
        } else {
          throw "[Disk]: Unsupported moving of these filesystems";
        }

        res.path = join(rootPrefix(dirPath), res.path);
        return res;
      }
    }
    throw "[Disk]: FileSystems don't mount.";
  }

  @override
  void delete(
    String path, {
    bool recursive = false,
    EntityType type = EntityType.file,
  }) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(path);
    if (fs != null && rPath != null) {
      return fs.delete(rPath, recursive: recursive);
    }
    throw "[Disk]: FileSystems don't mount.";
  }

  @override
  bool exists(
    String path, {
    EntityType type = EntityType.file,
  }) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(path);
    if (fs != null && rPath != null) {
      return fs.exists(rPath);
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
  Stream<List<int>> openRead(String filePath) async* {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(filePath);
    if (fs != null && rPath != null) {
      yield* fs.openRead(rPath);
    }
  }

  @override
  Stat stat(
    String path, {
    EntityType type = EntityType.file,
  }) {
    var (fs, rPath) = getFileSystemAndRelativePathByPath(path);
    if (fs != null && rPath != null) {
      return fs.stat(rPath);
    }
    throw "[Disk]: FileSystems don't mount.";
  }
}
