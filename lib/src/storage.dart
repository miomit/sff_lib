import 'dart:io';

/// Enumerating wirh permission of [Storage].
enum Permission { read, write, all }

/// Class for opening a directory with a specified permission.
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

  @override
  String toString() {
    var res = name == null ? "" : "[$name]: ";
    res += "(${_dir.path}) $_perm";
    return res;
  }
}
