import 'package:sff_lib/services.dart';

abstract interface class IStatFileService implements IStatService {
  DateTime get changed;
}