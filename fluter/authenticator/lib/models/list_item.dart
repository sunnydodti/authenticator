import 'dart:ui';

import 'package:authenticator/enums/list_item_type.dart';
import 'package:authenticator/models/auth_item.dart';
import 'package:authenticator/models/group.dart';

class ListItem {
  final int id;
  final ListItemType type;
  final Group? group;
  final AuthItem? authItem;
  VoidCallback? onClick;

  ListItem(this.id, this.type, this.group, this.authItem);
}