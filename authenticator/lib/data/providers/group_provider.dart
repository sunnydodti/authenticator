import 'package:authenticator/constants/constants.dart';
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
  List<Group> groupStack = [];
  List<Group> _selectedGroups = [];

  Group? _currentGroup;

  Group? get currentGroup => _currentGroup;

  Future<void> setCurrentGroupById(int id) async {
    GroupService service = await _groupService;
    Group? group = await service.getGroupById(id);
    _currentGroup = group;
  }

  Future<void> setSelectedGroups(List<Group> selectedGroups) async {
    _selectedGroups = selectedGroups;
  }

  /// Get list of all groups
  List<Group> get groups => _groups;

  void pushGroup(Group group, {bool refreshData = true}) {
    _currentGroup = group;
    groupStack.add(group);
    if (refreshData) refreshSelected();
  }

  void popGroup({bool refreshData = true}) {
    if (groupStack.isNotEmpty) {
      groupStack.removeLast();
      _currentGroup = (groupStack.isNotEmpty) ? groupStack.last : null;
      if (refreshData) refreshSelected();
    }
  }

  /// Add an group item in memory (not DB)
  void addGroup(Group item) {
    _groups.add(item);
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
  Future<void> refreshSelected(
      {bool notify = true, bool skipSelected = true}) async {
    try {
      int parentId = Constants.db.group.defaultGroupId;
      if (_currentGroup != null) parentId = _currentGroup!.id!;
      List<Group> items = await _getGroupsIn(parentId);
      if (skipSelected) {
        for (Group group in _selectedGroups) {
          items.removeWhere((element) => element.id == group.id);
        }
      }
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

  /// Fetch updated groups with parent from DB
  Future<List<Group>> _getGroupsIn(int parentId) async {
    GroupService groupService = await _groupService;
    return await groupService.getGroupsIn(parentId);
  }

  /// create Auth Item in DB
  void createGroup(Group item) async {
    GroupService service = await _groupService;
    if (await service.addGroup(item) > 0) refresh();
  }

  /// create Auth Item in DB
  Future<int> createNewGroup(String name, int parentId) async {
    GroupService service = await _groupService;
    var result = await service.createNewGroup(name, parentId);

    if (result > 0) return result;
    return -1;
  }
}
