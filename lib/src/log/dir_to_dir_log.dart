import 'package:sff_lib/log.dart';

class DirToDirLog extends Log {
  final String uriDir1;
  final String uriDir2;

  DirToDirLog(
    this.uriDir1,
    this.uriDir2, {
    required super.type,
    required super.message,
  });

  DirToDirLog.info(
    this.uriDir1,
    this.uriDir2,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uriDir1 to $uriDir2",
        );

  DirToDirLog.error(
    this.uriDir1,
    this.uriDir2,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uriDir1 to $uriDir2",
        );

  DirToDirLog.success(
    this.uriDir1,
    this.uriDir2,
    ActionLog action,
  ) : super(
          type: TypeLog.success,
          message: "[${action.name}] $uriDir1 to $uriDir2",
        );
}
