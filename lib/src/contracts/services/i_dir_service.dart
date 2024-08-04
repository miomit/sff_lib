import 'package:sff_lib/services.dart';

/// additional features [IFilesystemEntityService] for interactions with directories.
abstract interface class IDirService implements IFilesystemEntityService {
  /// Lists the sub-directories and files of this [IDirService].
  Stream<IFilesystemEntityService> list({
    bool recursive = false,
    void Function(Exception e, IFilesystemEntityService fse)? onException,
  });
}
