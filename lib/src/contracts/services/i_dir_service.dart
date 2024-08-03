import 'package:sff_lib/services.dart';

abstract interface class IDirService implements IFilesystemEntityService {
  Stream<IFilesystemEntityService> list({
    bool recursive = false,
    void Function(Exception e, IFilesystemEntityService fse)? onException,
  });
}
