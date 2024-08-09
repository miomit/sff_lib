import 'package:crypto/crypto.dart';
import 'package:option_result/option.dart';
import 'package:option_result/result.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

class NativeDirService implements IDirService, IStatDirService {
  String _nativePath;

  NativeDirService(String path) : _nativePath = path;

  @override
  // TODO: implement count
  Future<int> get count => throw UnimplementedError();

  @override
  // TODO: implement created
  DateTime get created => throw UnimplementedError();

  @override
  // TODO: implement dirCount
  Future<int> get dirCount => throw UnimplementedError();

  @override
  Future<bool> exists() {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  bool existsSync() {
    // TODO: implement existsSync
    throw UnimplementedError();
  }

  @override
  // TODO: implement fileCount
  Future<int> get fileCount => throw UnimplementedError();

  @override
  // TODO: implement hash
  Digest get hash => throw UnimplementedError();

  @override
  Stream<IFilesystemEntityService> list(
      {bool recursive = false,
      void Function(Exception e, IFilesystemEntityService fse)? onException}) {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement parent
  IDirService get parent => throw UnimplementedError();

  @override
  // TODO: implement path
  String get path => throw UnimplementedError();

  @override
  // TODO: implement realPath
  Option<String> get realPath => throw UnimplementedError();

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
