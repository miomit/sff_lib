import 'package:crypto/crypto.dart';
import 'package:option_result/option.dart';
import 'package:option_result/result.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

class VirtualFileService implements IFileService, IStatFileService {
  final String _name;
  Option<VirtualDirService> _parent = None();
  Option<IIOService> _io = None();

  final DateTime _created = DateTime.now();
  final DateTime _changed = DateTime.now();

  final List<int> _data;

  VirtualFileService(
    String name, {
    List<int>? data,
  })  : _name = name,
        _data = data ?? [];

  @override
  DateTime get created => _created;

  @override
  DateTime get changed => _changed;

  set io(IIOService io) {
    _io = Some(io);
  }

  set parent(VirtualDirService dir) {
    _parent = Some(dir);
  }

  @override
  VirtualDirService get parent => _parent.unwrap();

  @override
  Future<Result<IFileService, IOError>> copy(String newPath) {
    return Future.value(copySync(newPath));
  }

  @override
  Result<IFileService, IOError> copySync(String newPath) {
    if (_io is None) {
      return Err(IOError.doesNotExist);
    }

    return switch (_io.unwrap().copy(path, newPath)) {
      Ok(value: IFileService file) => Ok(file),
      Err(value: IOError err) => Err(err),
      _ => Err(IOError.unsupportedFormat),
    };
  }

  @override
  Future<bool> exists() => Future.value(existsSync());

  @override
  bool existsSync() => _io.isSomeAnd((io) => io.open(path) is Ok);

  @override
  String get name => _name;

  Stream<List<int>> _read() async* {
    for (var i = 0; i < _data.length; i += 250) {
      yield _data.sublist(i, i + 250);
    }
  }

  @override
  Result<Stream<List<int>>, IOError> openRead() {
    if (existsSync()) {
      return Ok(_read());
    }

    return Err(IOError.doesNotExist);
  }

  @override
  String get path => switch (_parent) {
        Some() => "${parent.path}\\$_name",
        None() => name,
      };

  @override
  Option<String> get realPath => None();

  @override
  int get size => _data.length;

  @override
  Future<IStatService> stat() => Future.value(this);

  @override
  IStatService statSync() => this;

  @override
  Digest get hash => sha1.convert(_data);
}
