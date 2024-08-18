import 'package:sff_lib/log.dart';

class FileLog extends Log {
  final String uri;

  FileLog(
    this.uri, {
    required super.type,
    required super.message,
  });

  FileLog.info(
    this.uri,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uri",
        );

  FileLog.error(
    this.uri,
    ActionLog action,
  ) : super(
          type: TypeLog.error,
          message: "[${action.name}] $uri",
        );

  FileLog.success(
    this.uri,
    ActionLog action,
  ) : super(
          type: TypeLog.success,
          message: "[${action.name}] $uri",
        );
}
