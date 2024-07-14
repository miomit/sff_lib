import 'dart:io';

import 'package:async/async.dart';
import 'package:sff_lib/sff_lib.dart'
    show Storage, Permission, FileLog, SffYaml;
import 'package:sff_lib/src/file.dart' as sff_file;
import 'package:sff_lib/src/dir.dart' as sff_dir;

/// A class for executing actions on sets
/// of directories ([Storage]) simultaneously.
class Sff {
  final List<Storage> _dirIn = [];
  final List<Storage> _dirOut = [];
  final List<Storage> _dirSync = [];

  String? name;

  Sff(
    List<Storage> storageList, {
    this.name,
  }) {
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

  static Stream<FileLog> runConfigFile(String path) {
    List<Stream<FileLog>> res = [];
    final config = SffYaml.parse(File(path).readAsStringSync());

    //copyRec
    if (config.run["copy"] case List copyList) {
      for (String key in copyList) {
        if (config.event[key] != null) {
          res.add(
            Sff(
              config.event[key]!,
              name: key,
            ).copyRec(),
          );
        }
      }
    }

    //sync
    if (config.run["sync"] case List syncList) {
      for (String key in syncList) {
        if (config.event[key] != null) {
          res.add(
            Sff(
              config.event[key]!,
              name: key,
            ).sync(),
          );
        }
      }
    }

    return StreamGroup.merge(res);
  }

  Stream<FileLog> findDuplicates({
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

  Stream<FileLog> sync({
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

  Stream<FileLog> copyRec({
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
