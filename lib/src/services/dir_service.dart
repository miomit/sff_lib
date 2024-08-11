import 'package:sff_lib/services.dart';

class DirService extends FilesystemEntityService {
  DirService(super.path);

  /// Lists the sub-directories and files of this [IDirService].
  Stream<FilesystemEntityService> list({
    bool recursive = false,
    void Function(Exception e, FilesystemEntityService fse)? onException,
  }) async* {
    await for (final entity in fs.list(path)) {
      try {
        yield entity;

        if (recursive && entity is DirService) {
          yield* entity.list(
            recursive: true,
            onException: onException,
          );
        }
      } on Exception catch (e) {
        if (onException != null) {
          onException(e, entity);
        } else {
          rethrow;
        }
      } catch (_) {
        rethrow;
      }
    }
  }
}
