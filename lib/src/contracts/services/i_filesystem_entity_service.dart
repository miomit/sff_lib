import 'package:sff_lib/services.dart';

abstract interface class IFilesystemEntityService {
  IDirService get parent;
  String get path;

  Future<bool> exists();
  bool existsSync();

  Future<T> stat<T extends IStatService>();
  T statSync<T extends IStatService>();
}