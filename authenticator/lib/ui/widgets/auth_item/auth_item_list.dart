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
                                bool isSelected =
                                    provider.selectedItems[index]!;
                                ListItem item = provider.items[index];
                                if (item.type == ListItemType.group) {
                                  return buildGroupTile(
                                      item, isSelected, index, provider);
                                }
                                return buildAuthItemTile(
                                    item, isSelected, index, provider);
                              })));
            },
          );
        },
      ),
    );
  }

  AuthItemTile buildAuthItemTile(
      ListItem item, bool isSelected, int index, DataProvider provider) {
    return AuthItemTile(
      authItem: item.authItem!,
      isSelected: isSelected,
      onSelect: () => onItemSelect(index, provider),
      onToggle: () => onItemToggle(index, provider, isSelected),
      onTap: () {
        if (provider.isSelectionMode) onItemToggle(index, provider, isSelected);
      },
    );
  }

  GroupTile buildGroupTile(
      ListItem item, bool isSelected, int index, DataProvider provider) {
    return GroupTile(
      group: item.group!,
      isSelected: isSelected,
      isSelectionMode: provider.isSelectionMode,
      onSelect: () => onItemSelect(index, provider),
      onToggle: () => onItemToggle(index, provider, isSelected),
      onTap: () => onItemToggle(index, provider, isSelected),
    );
  }

  Future<void> _refresh(BuildContext context, {bool notify = true}) async {
    // final provider = Provider.of<AuthItemProvider>(context, listen: false);
    // await provider.refresh(notify: notify);
    final provider = Provider.of<DataProvider>(context, listen: false);
    await provider.refresh(notify: notify);
  }

  void onItemSelect(int index, DataProvider provider) {
    provider.updateSelectedItem(index, true);
  }

  void onItemUnSelect(int index, DataProvider provider) {
    provider.updateSelectedItem(index, false);
  }

  void onItemToggle(int index, DataProvider provider, bool isSelected) {
    isSelected
        ? onItemUnSelect(index, provider)
        : onItemSelect(index, provider);
  }

  void onItemTap(int index, DataProvider provider, bool isSelected) {
    if (provider.isSelectionMode) {
      onItemToggle(index, provider, isSelected);
    }
  }
}
