import 'dart:io';

import 'package:sff_lib/sff_lib.dart' show Storage, Permission;
import 'package:sff_lib/src/file.dart' as sff_file;
import 'package:sff_lib/src/dir.dart' as sff_dir;

class Sff {
  final List<Storage> _dirIn = [];
  final List<Storage> _dirOut = [];
  final List<Storage> _dirSync = [];

  Sff(
    List<Storage> storageList,
  ) {
    for (var storage in storageList) {
      switch (storage.getPerm()) {
        case Permission.read:
          _dirIn.add(storage);
          break;
        case Permission.write:
          _dirOut.add(storage);
          break;
        case Permission.all:
          _dirSync.add(storage);
          break;
      }
    }
  }

  Stream<(File, File)> findDuplicates({
    File? file,
    bool Function(String)? filter,
  }) {
    return sff_file.findDuplicates(
      [
        for (var dir in _dirIn) dir.getDir(),
        for (var dir in _dirSync) dir.getDir(),
      ],
      file: file,
      filter: filter,
    );
  }

  Stream<(File, File)> sync({
    bool isCopyFile = true,
    bool Function(String)? filter,
  }) async* {
    for (int i = 0; i < _dirSync.length - 1; i++) {
      for (int j = i + 1; j < _dirSync.length; j++) {
        yield* sff_dir.syncDir(
          _dirSync[i].getDir(),
          _dirSync[j].getDir(),
          isCopyFile: isCopyFile,
          filter: filter,
        );
      }
    }
  }

  Stream<(File, File)> copyRec({
    bool isCopyDirOutOnly = true,
    bool isCopyFile = true,
    bool Function(String)? filter,
  }) async* {
    for (var dirIn in _dirIn) {
      for (var dirOut in [..._dirOut, if (!isCopyDirOutOnly) ..._dirSync]) {
        yield* sff_dir.copyDirRec(
          dirIn.getDir(),
          dirOut.getDir(),
          isCopyFile: isCopyFile,
          filter: filter,
        );
      }
    }
  }
}
