import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants/constants.dart';
import '../../models/group.dart';

class GroupHelper {
  final Database _database;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  GroupHelper(this._database);

  Database get getDatabase => _database;

  static Future<void> createTable(Database database) async {
    var result = await database.rawQuery(
        """SELECT name FROM sqlite_master WHERE type = 'table' AND name = '${Constants.db.group.table}'""");

    if (result.isEmpty) {
      _logger.i("Creating table ${Constants.db.group.table}");
      await database.execute('''
        CREATE TABLE ${Constants.db.group.table} (
          ${Constants.db.group.id} INTEGER PRIMARY KEY AUTOINCREMENT, 
          ${Constants.db.group.name} TEXT NOT NULL,
          ${Constants.db.group.parentId} INTEGER,
          ${Constants.db.common.createdAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          ${Constants.db.common.modifiedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      _logger.i("creating trigger ${Constants.db.group.triggerModifiedAt}");
      await database.execute('''
        CREATE TRIGGER ${Constants.db.group.triggerModifiedAt}
        AFTER UPDATE ON ${Constants.db.group.table}
        BEGIN
          UPDATE ${Constants.db.group.table}
          SET modified_at = CURRENT_TIMESTAMP
          WHERE ROWID = NEW.ROWID;
        END;
      ''');

      _logger.i("adding default group");
      Group defaultGroup =
          Group(id: Constants.db.group.defaultGroupId, name: "default");
      await database.insert(Constants.db.group.table, defaultGroup.toMap());
    }
  }

  Future<int> addGroup(Map<String, dynamic> groupMap) async {
    _logger.i("Adding group");
    Database database = getDatabase;
    return await database.insert(Constants.db.group.table, groupMap);
  }

  Future<List<Map<String, dynamic>>> getGroups() async {
    _logger.i("Getting all groups");
    Database database = getDatabase;
    return await database.query(Constants.db.group.table);
  }

  Future<List<Map<String, dynamic>>> getGroupsIn(int groupId) async {
    _logger.i("Getting all groups");
    Database database = getDatabase;
    return await database.query(
      Constants.db.group.table,
      where: "${Constants.db.group.parentId} = ?",
      whereArgs: [groupId],
    );
  }

  Future<Map<String, dynamic>?> getGroupById(int id) async {
    _logger.i("Getting group by ID: $id");
    Database database = getDatabase;
    final result = await database.query(
      Constants.db.group.table,
      where: '${Constants.db.group.id} = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteGroupById(int id) async {
    _logger.i("Deleting group by ID: $id");
    Database database = getDatabase;
    return await database.delete(
      Constants.db.group.table,
      where: '${Constants.db.group.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateGroup(Group group) async {
    _logger.i("Updating group with ID: ${group.id}");
    Database database = getDatabase;
    return await database.update(
      Constants.db.group.table,
      group.toMap(),
      where: '${Constants.db.group.id} = ?',
      whereArgs: [group.id],
    );
  }

  Future<int> getGroupCount() async {
    _logger.i("Getting group count");
    Database database = getDatabase;
    final count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) FROM ${Constants.db.group.table}'));
    return count ?? 0;
  }

  Future<int> deleteAllGroups() async {
    _logger.i("Deleting all groups");
    Database database = getDatabase;
    return await database.delete(Constants.db.group.table);
  }
}
