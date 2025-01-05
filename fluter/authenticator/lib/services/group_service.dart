import 'package:authenticator/tools/logger.dart';
import 'package:logger/logger.dart';

import '../data/database/database_helper.dart';
import '../data/database/group_helper.dart';
import '../models/group.dart';

class GroupService {
  late final GroupHelper _groupHelper;
  static final Logger _logger = Log.logger;

  GroupService._(this._groupHelper);

  static Future<GroupService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final groupHelper = await databaseHelper.groupHelper;
    return GroupService._(groupHelper);
  }

  Future<List<Group>> getGroups() async {
    try {
      final List<Map<String, dynamic>> groupMaps =
          await _groupHelper.getGroups();
      return groupMaps.map((groupMap) => Group.fromMap(groupMap)).toList();
    } catch (e, stackTrace) {
      _logger.e("Error getting groups - $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Group>> getGroupsIn(int groupId) async {
    try {
      final List<Map<String, dynamic>> groupMaps =
          await _groupHelper.getGroupsIn(groupId);
      return groupMaps.map((groupMap) => Group.fromMap(groupMap)).toList();
    } catch (e, stackTrace) {
      _logger.e("Error getting groups - $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getGroupMaps() async {
    try {
      return await _groupHelper.getGroups();
    } catch (e, stackTrace) {
      _logger.e("Error getting group maps - $e - \n$stackTrace");
      return [];
    }
  }

  Future<Group?> getGroupById(int id) async {
    try {
      final groupMap = await _groupHelper.getGroupById(id);
      return groupMap != null ? Group.fromMap(groupMap) : null;
    } catch (e, stackTrace) {
      _logger.e("Error getting group by ID ($id) - $e - \n$stackTrace");
      return null;
    }
  }

  Future<int> addGroup(Group group) async {
    try {
      final result = await _groupHelper.addGroup(group.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding group - $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> updateGroup(Group group) async {
    try {
      final result = await _groupHelper.updateGroup(group);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error updating group - $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteGroup(String id) async {
    try {
      final result = await _groupHelper.deleteGroupById(id);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting group by ID ($id) - $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteAllGroups() async {
    try {
      final result = await _groupHelper.deleteAllGroups();
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting all groups - $e - \n$stackTrace");
      return -1;
    }
  }

  /// Check if a group with the same name exists (or other unique field).
  // Future<bool> isDuplicateGroup(String name) async {
  //   int count = await getGroupCountByName(name);
  //   return count > 0;
  // }

  /// Get the count of groups by a specific field (e.g., name).
  // Future<int> getGroupCountByName(String name) async {
  //   try {
  //     final count = await _groupHelper.getGroupCountByName(name);
  //     return count;
  //   } catch (e, stackTrace) {
  //     _logger.e("Error getting group count by name ($name) - $e - \n$stackTrace");
  //     return 0;
  //   }
  // }


  /// create a new group with/without parent
  Future<int> createNewGroup(String name, int parentId,
      {bool isLeaf = true}) async {
    try {
      Group group = Group(
        id: -1,
        name: name,
        isLeaf: isLeaf,
        parentId: parentId,
      );
      final result = await _groupHelper.addGroup(group.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error creating group $name - $e - \n$stackTrace");
      return -1;
    }
  }
}
