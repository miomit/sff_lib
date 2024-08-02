import 'package:sff_lib/services.dart';

abstract interface class IFilesystemEntityService {
  IDirService get parent;
  String get path;

  Future<bool> exists();
  bool existsSync();

  Future<IStatService> stat();
  IStatService statSync();
}
