import 'dart:io';

import 'package:option_result/option.dart';
import 'package:option_result/result.dart';
import 'package:sff_lib/services.dart';
import 'package:sff_lib/src/errors/io_error.dart';

class NativeFilesystemService implements IFilesystemService {
  NativeDirService _root;
  Option<IIOService> _io = None();

  NativeFilesystemService(String path) : _root = NativeDirService(path);

  @override
  Result<(), IOError> connect(IIOService io) {
    _io = Some(io);
    return Ok(());
  }

  @override
  Result<IFilesystemEntityService, IOError> copy(
    IFilesystemEntityService entityIn,
    IDirService dirOut,
  ) {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Result<(), IOError> delete(String path) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Result<(), IOError> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Result<IFilesystemEntityService, IOError> find(path) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Result<IFilesystemEntityService, IOError> mkdir(path) {
    // TODO: implement mkdir
    throw UnimplementedError();
  }

  @override
  Result<IFilesystemEntityService, IOError> move(
      IFilesystemEntityService entityIn, IDirService dirOut) {
    // TODO: implement move
    throw UnimplementedError();
  }

  @override
  // TODO: implement rootPath
  String get rootPath => throw UnimplementedError();

  @override
  Result<IFilesystemEntityService, IOError> touch(path) {
    // TODO: implement touch
    throw UnimplementedError();
  }
}
