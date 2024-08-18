import 'package:sff_lib/log.dart';

class Log {
  final DateTime dateTime;
  final TypeLog type;
  final String message;

  Log({
    required this.type,
    required this.message,
  }) : dateTime = DateTime.now();

  Log.info(String message) : this(type: TypeLog.info, message: message);
  Log.error(String message) : this(type: TypeLog.error, message: message);
  Log.warring(String message) : this(type: TypeLog.warring, message: message);
  Log.success(String message) : this(type: TypeLog.success, message: message);

  @override
  String toString() {
    return "[$dateTime]\t${type.name}\t$message";
  }
}
