import 'package:logger/logger.dart';

class Log {
  static Logger get logger =>
      Logger(printer: SimplePrinter(), level: Level.info);
}
