import 'dart:io';

enum Permission { copy, write, all }

class Storage {
  final Directory _dir;
  final Permission _perm;

  String? name;

  Storage(this._dir, this._perm, [this.name]);

  Directory getDir() => _dir;
  String getPath() => _dir.path;
  Permission getPerm() => _perm;

  bool isExists() => _dir.existsSync();
  int size() => _dir.statSync().size;
}
