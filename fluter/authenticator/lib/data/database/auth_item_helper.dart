import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants/constants.dart';

class AuthItemHelper {
  final Database _database;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  AuthItemHelper(this._database);

  Database get getDatabase => _database;

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${Constants.db.authItem.table}'""");

    if (result.isEmpty) {
      _logger.i("creating table ${Constants.db.authItem.table}");
      await database.execute('''CREATE TABLE ${Constants.db.authItem.table} (
        ${Constants.db.authItem.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Constants.db.authItem.name} TEXT,
        ${Constants.db.authItem.secret} TEXT UNIQUE,
        ${Constants.db.authItem.groupId} INTEGER DEFAULT ${Constants.db.group.table},
        ${Constants.db.common.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${Constants.db.common.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      ''');

      _logger.i("creating trigger ${Constants.db.authItem.triggerModifiedAt}");
      await database.execute('''
        CREATE TRIGGER ${Constants.db.authItem.triggerModifiedAt}
        AFTER UPDATE ON ${Constants.db.authItem.table}
        BEGIN
          UPDATE ${Constants.db.authItem.table}
          SET modified_at = CURRENT_TIMESTAMP
          WHERE ROWID = NEW.ROWID;
        END;
      ''');
    }
  }

  Future<int> addAuthItem(Map<String, dynamic> authItemMap) async {
    _logger.i("adding auth item");
    Database database = getDatabase;
    return await database.insert(Constants.db.authItem.table, authItemMap);
  }

  Future<List<Map<String, dynamic>>> getAuthItems() async {
    _logger.i("getting auth items");
    Database database = getDatabase;
    return await database.query(Constants.db.authItem.table);
  }

  Future<List<Map<String, dynamic>>> getAuthItemsForGroup(int groupId) async {
    _logger.i("getting auth items");
    Database database = getDatabase;
    return await database.query(
      Constants.db.authItem.table,
      where: "${Constants.db.authItem.groupId} = ?",
      whereArgs: [groupId],
    );
  }

  Future<Map<String, dynamic>?> getAuthItemBySecret(String secret) async {
    _logger.i("getting auth item by secret $secret");
    Database database = getDatabase;
    final result = await database.query(
      Constants.db.authItem.table,
      where: '${Constants.db.authItem.secret} = ?',
      whereArgs: [secret],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteAuthItemById(int id) async {
    _logger.i("deleting auth item by id $id");
    Database database = getDatabase;
    return await database.delete(
      Constants.db.authItem.table,
      where: '${Constants.db.authItem.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAuthItemBySecret(String secret) async {
    _logger.i("deleting auth item by secret $secret");
    Database database = getDatabase;
    return await database.delete(
      Constants.db.authItem.table,
      where: '${Constants.db.authItem.secret} = ?',
      whereArgs: [secret],
    );
  }

  Future<int> deleteAllAuthItems() async {
    _logger.i("deleting all auth items");
    Database database = getDatabase;
    return await database.delete(Constants.db.authItem.table);
  }

  Future<int> getAuthItemCount() async {
    _logger.i("getting auth item count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) FROM ${Constants.db.authItem.table}'));
    return count ?? 0;
  }
}
