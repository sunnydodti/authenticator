import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../models/group.dart';
import '../../services/group_service.dart';

class GroupProvider extends ChangeNotifier {
  late final Future<GroupService> _groupService;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  GroupProvider() {
    _init();
  }

  Future<void> _init() async {
    _groupService = GroupService.create();
  }

  List<Group> _groups = [];

  /// Get list of all groups
  List<Group> get groups => _groups;

  Group? _currentGroup;

  Group? get currentGroup => _currentGroup;

  set setCurrentGroup(Group group) => _currentGroup = group;

  /// Add an group item in memory (not DB)
  void addGroup(Group item) {
    _groups.add(item);
    notifyListeners();
  }

  /// Insert an group at a specific index (not DB)
  void insertGroup(int index, Group item) {
    _groups.insert(index, item);
    notifyListeners();
  }

  /// Get group by ID (not from DB)
  Group? getGroup(int id) {
    try {
      return _groups.firstWhere((item) => item.id == id);
    } catch (e, stackTrace) {
      _logger.e('Error getting group ($id): $e - \n$stackTrace');
      return null;
    }
  }

  /// Edit an group in memory (not DB)
  void editGroup(Group editedItem) {
    final index = _groups.indexWhere((item) => item.id == editedItem.id);
    if (index != -1) {
      _groups[index] = editedItem;
      notifyListeners();
    }
  }

  /// Delete an group by ID (not DB)
  void deleteGroup(int id) {
    _groups.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Refresh groups from DB
  Future<void> refresh({bool notify = true}) async {
    try {
      List<Group> items = await _getGroups();
      _groups = items;
      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing groups: $e - \n$stackTrace');
    }
  }

  /// Refresh groups from DB
  Future<void> refreshGroupData(int id, {bool notify = true}) async {
    try {
      List<Group> items = await _getGroups();
      _groups = items;
      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing groups: $e - \n$stackTrace');
    }
  }

  /// Fetch updated groups from DB
  Future<List<Group>> _getGroups() async {
    GroupService groupService = await _groupService;
    return await groupService.getGroups();
  }

  /// create Auth Item in DB
  void createGroup(Group item) async {
    GroupService service = await _groupService;
    if (await service.addGroup(item) > 0) refresh();
  }

  /// create Auth Item in DB
  Future<void> createNewGroup(String name, {bool isLeaf = true}) async {
    GroupService service = await _groupService;
    var result = await service.createNewGroup(name, parent: _currentGroup, isLeaf: isLeaf);
    // if (await service.addGroup(item) > 0) refresh();

    int a = 0;
  }
}
