import 'package:authenticator/tools/logger.dart';
import 'package:logger/logger.dart';

import '../data/database/auth_item_helper.dart';
import '../data/database/database_helper.dart';
import '../models/auth_item.dart';

class AuthItemService {
  late final AuthItemHelper _authItemHelper;
  static final Logger _logger = Log.logger;

  AuthItemService._(this._authItemHelper);

  static Future<AuthItemService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final authItemHelper = await databaseHelper.authItemHelper;
    return AuthItemService._(authItemHelper);
  }

  Future<List<AuthItem>> getAuthItems() async {
    try {
      final List<Map<String, dynamic>> authItems =
          await _authItemHelper.getAuthItems();
      return authItems
          .map((authItemMap) => AuthItem.fromMap(authItemMap))
          .toList();
    } catch (e, stackTrace) {
      _logger.e("Error getting auth_items - $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<AuthItem>> getAuthItemsForGroup(int groupId) async {
    try {
      final List<Map<String, dynamic>> authItems =
          await _authItemHelper.getAuthItemsForGroup(groupId);
      return authItems
          .map((authItemMap) => AuthItem.fromMap(authItemMap))
          .toList();
    } catch (e, stackTrace) {
      _logger.e("Error getting auth_items - $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAuthItemMaps() async {
    try {
      return await _authItemHelper.getAuthItems();
    } catch (e, stackTrace) {
      _logger.e("Error getting auth_item: $e - \n$stackTrace");
      return [];
    }
  }

  /// Get an auth_item by its name (or any unique identifier)
  // Future<AuthItem?> getAuthItemByName(String name) async {
  //   try {
  //     final List<Map<String, dynamic>> authItem =
  //     await _authItemHelper.getAuthItemByName(name);
  //     return AuthItem.fromMap(authItem.first);
  //   } catch (e, stackTrace) {
  //     _logger.e("Error getting auth_item ($name) - $e - \n$stackTrace");
  //     return null;
  //   }
  // }

  Future<int> addAuthItem(AuthItem name) async {
    try {
      final result = await _authItemHelper.addAuthItem(name.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding auth_item - $e - \n$stackTrace");
      return -1;
    }
  }

  // Future<int> updateAuthItem(AuthItem name) async {
  //   try {
  //     final result = await _authItemHelper.updateAuthItem(name);
  //     return result;
  //   } catch (e, stackTrace) {
  //     _logger.e("Error updating auth_item - $e - \n$stackTrace");
  //     return -1;
  //   }
  // }

  Future<int> deleteAuthItem(int id) async {
    try {
      final result = await _authItemHelper.deleteAuthItemById(id);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting auth_item - $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteAllAuthItems() async {
    try {
      final result = await _authItemHelper.deleteAllAuthItems();
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting all auth_item - $e - \n$stackTrace");
      return -1;
    }
  }

  /// Check if a duplicate auth_item exists (by some unique field like name)
  Future<bool> isDuplicateAuthItem(String name) async {
    int count = await getAuthItemCount(name);
    return count > 0;
  }

  /// Get the count of auth_item by name (or other unique identifier)
  Future<int> getAuthItemCount(String name) async {
    // final List<Map<String, dynamic>> result =
    // await _authItemHelper.getAuthItemCount(name);
    // int? count = Sqflite.firstIntValue(result);
    // return count ?? 0;
    return 0;
  }
}
