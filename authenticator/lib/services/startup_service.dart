import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pwa_install/pwa_install.dart';

class StartUpService {
  static Future initialize() async {
    await _init();
  }

  static Future _init() async {
    await _initHive();
    await _initPWA();
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();
    await Hive.openBox("box");
  }

  static Future _initPWA() async {
    PWAInstall().setup(installCallback: () {
      debugPrint('PWA INSTALLED!');
    });
  }
}
