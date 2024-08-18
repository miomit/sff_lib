import 'package:sff_lib/log.dart';

class FileToDirLog extends Log {
  final String uriFile;
  final String uriDir;

  FileToDirLog(
    this.uriFile,
    this.uriDir, {
    required super.type,
    required super.message,
  });

  FileToDirLog.info(
    this.uriFile,
    this.uriDir,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uriFile to $uriDir",
        );

  FileToDirLog.error(
    this.uriFile,
    this.uriDir,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uriFile to $uriDir",
        );

  FileToDirLog.success(
    this.uriFile,
    this.uriDir,
    ActionLog action,
  ) : super(
          type: TypeLog.success,
          message: "[${action.name}] $uriFile to $uriDir",
        );
}
