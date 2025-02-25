import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../../constants/constants.dart';
import '../../tools/logger.dart';
import 'auth_item_helper.dart';
import 'group_helper.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  final _logger = Log.logger;
  static Database? _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get getDatabase async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    return _database ??= await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    String path = "";
    if (kIsWeb) {
      "/assets/db/${Constants.db.databaseName}";
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();
      path = '${directory.path}/${Constants.db.databaseName}';
    }
    // await deleteDatabase(path);
    return await openDatabase(
      path,
      version: Constants.db.databaseVersion,
      onCreate: createDatabase,
      onUpgrade: upgradeDatabase,
      onOpen: (db) {
        _logger.i(path);
        _logger.i("Database is open");
      },
    );
  }

  Future<void> upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    // if upgrading from version 1
    if (oldVersion == 1) {
      await upgradeFromV1toV2(db);
    }
  }

  void createDatabase(Database database, int newVersion) async {
    // version 1
    await AuthItemHelper.createTable(database);
    await GroupHelper.createTable(database);
  }

  Future upgradeFromV1toV2(Database database) async {
    // MigrationHelper.migrateV1toV2(database);
  }

  Future<AuthItemHelper> get authItemHelper async =>
      AuthItemHelper(await getDatabase);

  Future<GroupHelper> get groupHelper async => GroupHelper(await getDatabase);
}
