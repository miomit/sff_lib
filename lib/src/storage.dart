import 'dart:io';
import 'dart:js_interop';

enum Permission { copy, write, all }

class Storage {
  final Directory _dir;
  final Permission _perm;

  Storage(this._dir, this._perm);

  Directory getDir() => _dir;
  String getPath() => _dir.path;
  Permission getPerm() => _perm;

  bool isExists() => _dir.existsSync();
  int size() => _dir.statSync().size;
}
