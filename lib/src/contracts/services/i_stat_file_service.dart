import 'package:sff_lib/services.dart';

/// Additional meta data for file.
abstract interface class IStatFileService implements IStatService {
  /// Last modified time.
  DateTime get changed;
}
