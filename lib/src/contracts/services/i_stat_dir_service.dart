import 'package:sff_lib/services.dart';

abstract interface class IStatDirService implements IStatService {
  Future<int> get count;

  Future<int> get fileCount;
  Future<int> get dirCount;
}
