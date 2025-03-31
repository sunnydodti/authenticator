import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class StartUpService {
  static Future initialize() async {
    await _init();
  }

  static Future _init() async {
    await _initHive();
    await _initPWA();
    await initSqflite();
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

  static Future initSqflite() async {
    // web
    if (kIsWeb) {
      // databaseFactory = databaseFactoryFfiWeb;
      databaseFactoryOrNull = databaseFactoryFfiWeb;

    } else if (Platform.isLinux || Platform.isWindows) {
      // sqfliteFfiInit();
      // databaseFactoryOrNull = databaseFactoryFfi;
    }
    //desktop

    //mobile
  }
}
