import 'package:hive_ce_flutter/adapters.dart';

class StartUpService {
  static Future initialize() async {
    await _init();
  }

  static Future _init() async {
    await _initHive();
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    await Hive.openBox("box");
  }
}
