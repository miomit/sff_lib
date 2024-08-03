import 'package:option_result/option_result.dart';
import 'package:path/path.dart';
import 'package:sff_lib/errors.dart';
import 'package:sff_lib/services.dart';

class VirtualDirService implements IDirService, IStatDirService {
  final String _name;
  Option<VirtualDirService> _parent = None();
  Option<IIOService> _io = None();

  final List<VirtualDirService> _dirChildren = [];
  final List<VirtualFileService> _fileChildren = [];

  final DateTime _created = DateTime.now();

  VirtualDirService(
    String name, {
    List<IFilesystemEntityService>? children,
  }) : _name = name {
    if (children != null) {
      addChildren(children);
    }
  }

  @override
  VirtualDirService get parent => _parent.unwrapOr(this);

  set io(IIOService io) {
    _io = Some(io);
  }

  set parent(VirtualDirService dir) {
    _parent = Some(dir);
  }

  Result<(), IOError> _removeFileChild(VirtualFileService file) {
    return _fileChildren.remove(file) ? Ok(()) : Err(IOError.doesNotExist);
  }

  Result<(), IOError> _removeDirChild(VirtualDirService dir) {
    return _dirChildren.remove(dir) ? Ok(()) : Err(IOError.doesNotExist);
  }

  Result<(), IOError> addChild(IFilesystemEntityService fse) {
    switch (getChildByName(basename(fse.path))) {
      case Some(value: VirtualFileService _):
        return Err(IOError.fileExist);
      case Some(value: VirtualDirService _):
        return Err(IOError.dirExist);
      default:
        if (fse case VirtualFileService file) {
          file.io = _io.unwrap();
          file.parent = parent;
          _fileChildren.add(file);
        } else if (fse case VirtualDirService dir) {
          dir.io = _io.unwrap();
          dir.parent = parent;
          _dirChildren.add(dir);
        } else {
          return Err(IOError.unsupportedFormat);
        }
    }
    return Ok(());
  }

  Result<(), IOError> addChildren(List<IFilesystemEntityService> children) {
    for (final child in children) {
      final status = addChild(child);
      if (status.isErr()) {
        return status;
      }
    }

    return Ok(());
  }

  Result<(), IOError> removeChild(IFilesystemEntityService fse) =>
      switch (fse) {
        VirtualFileService file => _removeFileChild(file),
        VirtualDirService dir => _removeDirChild(dir),
        _ => Err(IOError.unsupportedFormat),
      };

  Option<IFilesystemEntityService> getChildByName(String name) {
    for (final IFilesystemEntityService fse in [
      ..._dirChildren,
      ..._fileChildren,
    ]) {
      if (basename(fse.path) == name) {
        return Some(fse);
      }
    }

    return None();
  }

  @override
  Future<bool> exists() => Future.value(existsSync());

  @override
  bool existsSync() => _io.isSomeAnd((io) => io.open(path) is Ok);

  @override
  String get path => switch (_parent) {
        Some() => "${parent.path}\\$_name",
        None() => "$name:\\",
      };
  @override
  Future<IStatService> stat() => Future.value(this);

  @override
  IStatService statSync() => this;

  @override
  Future<int> get count async => (await dirCount) + (await fileCount);

  @override
  DateTime get created => _created;

  @override
  Future<int> get dirCount async {
    int count = _dirChildren.length;

    for (var dirChild in _dirChildren) {
      count += await dirChild.dirCount;
    }

    return count;
  }

  @override
  Future<int> get fileCount async {
    int count = _fileChildren.length;

    for (var dirChild in _dirChildren) {
      count += await dirChild.fileCount;
    }

    return count;
  }

  @override
  String get name => _name;

  @override
  Option<String> get realPath => None();

  @override
  int get size {
    int size = 0;

    for (var dirChild in _dirChildren) {
      size += dirChild.size;
    }

    for (var fileChild in _fileChildren) {
      size += fileChild.size;
    }

    return size;
  }

  @override
  Stream<IFilesystemEntityService> list({
    bool recursive = false,
    void Function(
      Exception e,
      IFilesystemEntityService fse,
    )? onException,
  }) async* {
    for (IFilesystemEntityService child in [
      ..._fileChildren,
      ..._dirChildren,
    ]) {
      try {
        yield child;
        if (recursive && child is VirtualDirService) {
          yield* child.list(
            recursive: true,
            onException: onException,
          );
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
