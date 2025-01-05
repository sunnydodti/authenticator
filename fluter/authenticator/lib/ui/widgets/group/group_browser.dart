import 'package:authenticator/models/list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/group_provider.dart';
import '../../../models/group.dart';

class GroupBrowser extends StatefulWidget {
  final int parentId;
  final List<ListItem> selectedItems;

  const GroupBrowser({
    super.key,
    required this.parentId,
    required this.selectedItems,
  });

  @override
  State<GroupBrowser> createState() => _GroupBrowserState();
}

class _GroupBrowserState extends State<GroupBrowser> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refresh(context, widget.parentId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Consumer<GroupProvider>(
          builder: (context, provider, child) {
            return Scrollbar(
              interactive: true,
              radius: const Radius.circular(5),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.groups.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return buildPopListTile(provider);
                    index--;
                    Group group = provider.groups[index];
                    return ListTile(
                      dense: true,
                      title: Text(group.name),
                      onTap: () => provider.pushGroup(group),
                    );
                  }),
            );
          },
        );
      },
    );
  }

  ListTile buildPopListTile(GroupProvider provider) {
    return ListTile(
      onTap: provider.popGroup,
      dense: true,
      title: Text(".."),
    );
  }

  Future<void> _refresh(BuildContext context, int parentId,
      {bool notify = true}) async {
    final provider = Provider.of<GroupProvider>(context, listen: false);
    await provider.setCurrentGroupById(parentId);
    await provider.refreshSelected(notify: notify);
  }
}
