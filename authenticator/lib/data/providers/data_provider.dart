import 'package:authenticator/enums/list_item_type.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../constants/constants.dart';
import '../../models/auth_item.dart';
import '../../models/group.dart';
import '../../models/list_item.dart';
import '../../services/auth_item_service.dart';
import '../../services/group_service.dart';

class DataProvider extends ChangeNotifier {
  late final Future<AuthItemService> _authItemService;
  late final Future<GroupService> _groupService;

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  DataProvider() {
    _init();
  }

  Future<void> _init() async {
    _authItemService = AuthItemService.create();
    _groupService = GroupService.create();
  }

  List<ListItem> _items = [];
  List<Group> groupStack = [];

  Group? _currentGroup;

  /// Get list of all authenticator items
  List<ListItem> get items => _items;

  int get currentGroupId {
    if (_currentGroup == null) return Constants.db.group.defaultGroupId;
    return _currentGroup!.id!;
  }

  Group? get currentGroup => _currentGroup;

  bool canPop = false;
  bool isRoot = false;

  bool get isAtRoot => (currentGroup == null ||
      currentGroup!.id == Constants.db.group.defaultGroupId);

  void setCurrentGroup(Group group, {bool refreshData = false}) {
    _currentGroup = group;
    groupStack.add(group);
    canPop = false;
    if (refreshData) refresh();
  }

  void popCurrentGroup({bool refreshData = false}) {
    if (groupStack.isNotEmpty) {
      groupStack.removeLast();
      _currentGroup = (groupStack.isNotEmpty) ? groupStack.last : null;
      if (refreshData) refresh();
    }
  }

  bool _isSelectionMode = false;
  final Map<int, bool> _selectedItems = {};

  bool get isSelectionMode => _isSelectionMode;

  Map<int, bool> get selectedItems => _selectedItems;

  int get selectedCount =>
      _selectedItems.values.where((element) => element).length;

  List<ListItem> getSelectedItems() {
    List<ListItem> selectedItems = [];

    _selectedItems.forEach(
      (key, value) {
        if (value) selectedItems.add(_items[key]);
      },
    );
    return selectedItems;
  }

  void updateSelectedItem(int index, value) {
    _selectedItems[index] = value;
    if (value) {
      _isSelectionMode = true;
    } else {
      toggleUpdateSelectionMode();
    }
    notifyListeners();
  }

  void toggleUpdateSelectionMode() {
    bool isOneSelected = _selectedItems.values.any((element) => element);
    if (!isOneSelected) {
      _isSelectionMode = false;
      notifyListeners();
    }
  }

  void setIsSelectionMode(bool value) {
    _isSelectionMode = value;
    notifyListeners();
  }

  void clearSelected({bool notify = false}) {
    setIsSelectionMode(false);
    _setAll(false);
    if (notify) notifyListeners();
  }

  void selectAll() {
    setIsSelectionMode(true);
    _setAll(true);
  }

  void _setAll(bool value) {
    for (var key in _selectedItems.keys) {
      _selectedItems[key] = value;
    }
  }

  Future<int> deleteSelected({bool notify = true}) async {
    int deletedCount = 0;

    GroupService groupService = await _groupService;
    AuthItemService authItemService = await _authItemService;

    for (int i = 0; i < _items.length; i++) {
      if (_selectedItems[i]! == false) continue;

      ListItem item = _items[i];
      switch (item.type) {
        case ListItemType.group:
          if (await groupService.deleteGroup(item.group!.id!) != -1) {
            deletedCount += 1;
            break;
          }
        case ListItemType.authItem:
          if (await authItemService.deleteAuthItem(item.authItem!.id!) != -1) {
            deletedCount += 1;
            break;
          }
      }
    }

    setIsSelectionMode(false);
    _setAll(false);
    refresh();
    return deletedCount;
  }

  /// Add an authenticator item in memory (not DB)
  void addListItem(ListItem item) {
    _items.add(item);
    notifyListeners();
  }

  /// Insert an authenticator item at a specific index (not DB)
  void insertListItem(int index, ListItem item) {
    _items.insert(index, item);
    notifyListeners();
  }

  /// Get authenticator item by ID (not from DB)
  ListItem? getListItem(int id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e, stackTrace) {
      _logger.e('Error getting authenticator item ($id): $e - \n$stackTrace');
      return null;
    }
  }

  /// Edit an authenticator item in memory (not DB)
  void editListItem(ListItem editedItem) {
    final index = _items.indexWhere((item) => item.id == editedItem.id);
    if (index != -1) {
      _items[index] = editedItem;
      notifyListeners();
    }
  }

  /// Delete an authenticator item by ID (not DB)
  void deleteListItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Refresh data from DB
  Future<void> refresh({bool notify = true}) async {
    try {
      List<ListItem> items = await _getListItems();
      _items = items;
      _initializeSelectedItems(items.length);
      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing authenticator items: $e - \n$stackTrace');
    }
  }

  void _initializeSelectedItems(int length) {
    for (int i = 0; i < length; i++) {
      _selectedItems[i] = false;
    }
  }

  /// Fetch updated data from DB
  Future<List<ListItem>> _getListItems() async {
    AuthItemService authItemService = await _authItemService;
    GroupService groupService = await _groupService;

    int groupId = _currentGroup != null
        ? _currentGroup!.id!
        : Constants.db.group.defaultGroupId;

    List<AuthItem> authItems =
        await authItemService.getAuthItemsForGroup(groupId);

    List<Group> groups = await groupService.getGroupsIn(groupId);

    List<ListItem> listItems = <ListItem>[];
    int count = 0;
    for (var e in groups) {
      count++;
      listItems.add(ListItem(count, ListItemType.group, e, null));
    }
    for (var e in authItems) {
      count++;
      listItems.add(ListItem(count, ListItemType.authItem, null, e));
    }

    return listItems;
  }

  void resetStackTo(Group group) {
    if (groupStack.last == group) return;
    List<Group> newStack = [];

    for (Group g in groupStack) {
      if (!(g == group)) {
        newStack.add(g);
        continue;
      }
      newStack.add(g);
      break;
    }
    groupStack = newStack;
    _currentGroup = group;
    refresh();
  }

  Future<bool> moveSelectedItems(Group? parent) async {
    if (parent == null) return false;

    bool isUpdated = false;

    GroupService groupService = await _groupService;
    AuthItemService authItemService = await _authItemService;

    for (int key = 0; key < _selectedItems.length; key++) {
      bool value = _selectedItems[key]!;
      if (value) {
        ListItem selected = _items[key];
        switch (selected.type) {
          case ListItemType.group:
            {
              selected.group!.parentId = parent.id;
              await groupService.updateGroup(selected.group!);
              isUpdated = true;
            }
          case ListItemType.authItem:
            {
              selected.authItem!.groupId = parent.id;
              await authItemService.updateAuthItem(selected.authItem!);
              isUpdated = true;
            }
        }
      }
    }
    return isUpdated;
  }
}
