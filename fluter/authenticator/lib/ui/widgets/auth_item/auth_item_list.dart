import 'package:authenticator/enums/list_item_type.dart';
import 'package:authenticator/ui/widgets/auth_item/auth_item_tile.dart';
import 'package:authenticator/ui/widgets/group/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/data_provider.dart';
import '../../../models/list_item.dart';

class AuthItemList extends StatefulWidget {
  const AuthItemList({super.key});

  @override
  State<AuthItemList> createState() => _AuthItemListState();
}

class _AuthItemListState extends State<AuthItemList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _refresh(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Consumer<DataProvider>(
            builder: (context, provider, child) {
              return RefreshIndicator(
                  onRefresh: () => provider.refresh(),
                  child: provider.items.isEmpty
                      ? Center(child: Text('Click the + button to start'))
                      : Scrollbar(
                          interactive: true,
                          radius: const Radius.circular(5),
                          child: ListView.builder(
                              itemCount: provider.items.length,
                              itemBuilder: (context, index) {
                                ListItem item = provider.items[index];
                                if (item.type == ListItemType.group) {
                                  return GroupTile(group: item.group!);
                                }
                                return AuthItemTile(authItem: item.authItem!);
                              })));
            },
          );
        },
      ),
    );
  }

  Future<void> _refresh(BuildContext context, {bool notify = true}) async {
    // final provider = Provider.of<AuthItemProvider>(context, listen: false);
    // await provider.refresh(notify: notify);
    final provider = Provider.of<DataProvider>(context, listen: false);
    await provider.refresh(notify: notify);
  }
}
