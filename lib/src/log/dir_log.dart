import 'package:sff_lib/log.dart';

class DirLog extends Log {
  final String uri;

  DirLog(
    this.uri, {
    required super.type,
    required super.message,
  });

  DirLog.info(
    this.uri,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uri",
        );

  DirLog.error(
    this.uri,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uri",
        );

  DirLog.success(
    this.uri,
    ActionLog action,
  ) : super(
          type: TypeLog.success,
          message: "[${action.name}] $uri",
        );
}
