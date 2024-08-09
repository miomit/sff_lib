import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:option_result/option_result.dart';
import 'package:path/path.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

/// Virtual [IFileService] for [NativeFilesystemService].
class NativeFileService implements IFileService, IStatFileService {
  final File _file;

  NativeDirService _root;

  Option<FileStat> _stat = None();

  NativeFileService(String path, NativeDirService root)
      : _file = File(path),
        _root = root;

  @override
  DateTime get changed => _stat.unwrap().changed;

  @override
  Future<Result<IFileService, IOError>> copy(String newPath) {
    return Future.value(copySync(newPath));
  }

  @override
  Result<IFileService, IOError> copySync(String newPath) {
    // TODO copySync
    throw UnimplementedError();
  }

  @override
  DateTime get created => _stat.unwrap().modified;

  @override
  Future<bool> exists() => _file.exists();

  @override
  bool existsSync() => _file.existsSync();

  @override
  Digest get hash {
    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);

    final file = _file.openSync();

    for (int i = 0; i < statSync().size; i += 250) {
      input.add(file.readSync(250));
    }

    file.close();
    input.close();
    return output.events.single;
  }

  @override
  String get name => basename(path);

  Stream<List<int>> _read() async* {
    yield* _file.openRead();
  }

  @override
  Result<Stream<List<int>>, IOError> openRead() => Ok(_read());

  @override
  IDirService get parent => NativeDirService(path);

  @override
  String get path => throw UnimplementedError();

  @override
  Option<String> get realPath => Some(_file.path);

  @override
  Future<Result<IFilesystemEntityService, IOError>> rename(String newPath) {
    // TODO: implement rename
    throw UnimplementedError();
  }

  @override
  Result<IFilesystemEntityService, IOError> renameSync(String newPath) {
    // TODO: implement renameSync
    throw UnimplementedError();
  }

  @override
  // TODO: implement size
  int get size => throw UnimplementedError();

  @override
  Future<IStatService> stat() {
    // TODO: implement stat
    throw UnimplementedError();
  }

  @override
  IStatService statSync() {
    // TODO: implement statSync
    throw UnimplementedError();
  }
}
