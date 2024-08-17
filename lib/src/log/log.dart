import 'package:sff_lib/log.dart';

class Log {
  final DateTime dateTime;
  final LogType type;
  final String message;

  Log({
    required this.type,
    required this.message,
  }) : dateTime = DateTime.now();

  Log.info(String message) : this(type: LogType.info, message: message);
  Log.error(String message) : this(type: LogType.error, message: message);
  Log.warring(String message) : this(type: LogType.warring, message: message);
  Log.success(String message) : this(type: LogType.success, message: message);

  @override
  String toString() {
    return "[$dateTime]\t${type.name}\t$message";
  }
}
