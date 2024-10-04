import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../models/auth_item.dart';
import '../../services/auth_item_service.dart';

class AuthItemProvider extends ChangeNotifier {
  late final Future<AuthItemService> _authItemService;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  AuthItemProvider() {
    _init();
  }

  Future<void> _init() async {
    _authItemService = AuthItemService.create();
  }

  List<AuthItem> _authItems = [
    AuthItem(
        name: 'name',
        serviceName: 'serviceName',
        secret: 'secret1',
        code: 'code1'),
    AuthItem(
        name: 'name',
        serviceName: 'serviceName',
        secret: 'secret2',
        code: 'code2'),
    AuthItem(
        name: 'name',
        serviceName: 'serviceName',
        secret: 'secret3',
        code: 'code3'),
    AuthItem(
        name: 'name',
        serviceName: 'serviceName',
        secret: 'secret4',
        code: 'code4'),
  ];

  /// Get list of all authenticator items
  List<AuthItem> get authItems => _authItems;

  /// Add an authenticator item in memory (not DB)
  void addAuthItem(AuthItem item) {
    _authItems.add(item);
    notifyListeners();
  }

  /// Insert an authenticator item at a specific index (not DB)
  void insertAuthItem(int index, AuthItem item) {
    _authItems.insert(index, item);
    notifyListeners();
  }

  /// Get authenticator item by ID (not from DB)
  AuthItem? getAuthItem(int id) {
    try {
      return _authItems.firstWhere((item) => item.id == id);
    } catch (e, stackTrace) {
      _logger.e('Error getting authenticator item ($id): $e - \n$stackTrace');
      return null;
    }
  }

  /// Edit an authenticator item in memory (not DB)
  void editAuthItem(AuthItem editedItem) {
    final index = _authItems.indexWhere((item) => item.id == editedItem.id);
    if (index != -1) {
      _authItems[index] = editedItem;
      notifyListeners();
    }
  }

  /// Delete an authenticator item by ID (not DB)
  void deleteAuthItem(int id) {
    _authItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Refresh authenticator items from DB
  Future<void> refresh({bool notify = true}) async {
    try {
      List<AuthItem> items = await _getAuthItems();
      _authItems = items;
      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing authenticator items: $e - \n$stackTrace');
    }
  }

  /// Fetch updated authenticator items from DB
  Future<List<AuthItem>> _getAuthItems() async {
    AuthItemService authService = await _authItemService;
    return await authService.getAuthItems();
  }

  /// create Auth Item in DB
  void createAuthItem(AuthItem item) async {
    AuthItemService service = await _authItemService;
    if (await service.addAuthItem(item) > 0) refresh();
  }
}
