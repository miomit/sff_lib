import 'package:option_result/option.dart';
import 'package:option_result/result.dart';
import 'package:sff_lib/errors.dart';
import 'package:sff_lib/services.dart';

class VirtualDirService implements IDirService, IStatDirService {
  final String _name;
  final VirtualDirService? _parent;
  final IIOService _io;

  final List<VirtualDirService> _dirChildren = [];
  final List<VirtualFileService> _fileChildren = [];

  final DateTime _created = DateTime.now();

  VirtualDirService.root(
    String name,
    IIOService io,
  )   : _name = name,
        _parent = null,
        _io = io;

  Result<(), IOError> _addFileChild(VirtualFileService file) {
    if (getFileChildByName(file.name).isSome()) {
      return Err(IOError.fileExist);
    }

    _fileChildren.add(file);

    return Ok(());
  }

  Result<(), IOError> _addDirChild(VirtualDirService dir) {
    if (getDirChildByName(dir.name).isSome()) {
      return Err(IOError.dirExist);
    }

    _dirChildren.add(dir);

    return Ok(());
  }

  Result<(), IOError> _removeFileChild(VirtualFileService file) {
    return _fileChildren.remove(file) ? Ok(()) : Err(IOError.doesNotExist);
  }

  Result<(), IOError> _removeDirChild(VirtualDirService dir) {
    return _dirChildren.remove(dir) ? Ok(()) : Err(IOError.doesNotExist);
  }

  Result<(), IOError> addChild(IFilesystemEntityService fse) => switch (fse) {
        VirtualFileService file => _addFileChild(file),
        VirtualDirService dir => _addDirChild(dir),
        _ => Err(IOError.unsupportedFormat),
      };

  Result<(), IOError> removeChild(IFilesystemEntityService fse) =>
      switch (fse) {
        VirtualFileService file => _removeFileChild(file),
        VirtualDirService dir => _removeDirChild(dir),
        _ => Err(IOError.unsupportedFormat),
      };

  Option<IDirService> getDirChildByName(String name) {
    for (final dirChild in _dirChildren) {
      if (dirChild.name == name) {
        return Some(dirChild);
      }
    }

    return None();
  }

  Option<IFileService> getFileChildByName(String name) {
    for (final fileChild in _fileChildren) {
      if (fileChild.name == name) {
        return Some(fileChild);
      }
    }

    return None();
  }

  @override
  Future<bool> exists() => Future.value(existsSync());

  @override
  bool existsSync() => _io.open(path) is Ok;

  @override
  IDirService get parent => _parent ?? this;

  @override
  String get path {
    String parentPath = _parent?.path ?? "";
    return "$parentPath\\$_name";
  }

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
}
