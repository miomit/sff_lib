import 'package:sff_lib/services.dart';

abstract interface class IStatDirService implements IStatService {
  int get count => fileCount + dirCount;

  int get fileCount;
  int get dirCount;
}