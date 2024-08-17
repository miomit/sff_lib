import 'package:sff_lib/log.dart';

class Log {
  final DateTime dateTime;
  final LogType type;
  final String message;

  Log({
    required this.type,
    required this.message,
  }) : dateTime = DateTime.now();

  @override
  String toString() {
    return "[$dateTime]\t${type.name}\t$message";
  }
}
