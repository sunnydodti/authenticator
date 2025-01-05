import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/data/providers/group_provider.dart';
import 'package:authenticator/ui/widgets/group/add_group_button.dart';
import 'package:authenticator/ui/widgets/group/group_browser.dart';
import 'package:authenticator/ui/widgets/refresh_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarWidget({super.key, this.title = "Authenticator"});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
        if (provider.isSelectionMode) {
          return AppBar(
            leading: Center(
              child: Text(
                "${provider.selectedCount}",
              ),
            ),
            actions: buildSelectedActions(context, provider),
          );
        }
        return AppBar(
          title: Text(title, style: TextStyle()),
          centerTitle: true,
          backgroundColor: Constants.theme.dark.appBarColor,
          leading: RefreshButton(),
          actions: [
            AddGroupButton(),
          ],
        );
      },
    );
  }

  List<Widget> buildSelectedActions(
      BuildContext context, DataProvider provider) {
    return [
      IconButton(
        onPressed: () => moveItems(context, provider),
        icon: Icon(Icons.drive_file_move_outlined),
        tooltip: "Move Selected",
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.select_all_outlined),
        tooltip: "Select All",
      ),
      IconButton(
        onPressed: () => _clearSelected(provider),
        icon: Icon(Icons.clear_outlined),
        tooltip: "Clear Selected",
      ),
    ];
  }

  void moveItems(BuildContext context, DataProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        int count = provider.selectedCount;
        String title = buildTitle(count);
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            height: 500,
            width: 500,
            child: GroupBrowser(
              parentId: Constants.db.group.defaultGroupId,
              selectedItems: provider.getSelectedItems(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            buildMoveButton(context)
          ],
        );
      },
    );
  }

  Consumer<GroupProvider> buildMoveButton(BuildContext context) {
    DataProvider dataProvider =
        Provider.of<DataProvider>(context, listen: false);

    return Consumer<GroupProvider>(
        builder: (BuildContext context, GroupProvider provider, Widget? child) {
      String message = "Move Here";
      if (provider.currentGroup != null) {
        message = "Move to ${provider.currentGroup!.name}";
      }
      return TextButton(
          child: Text(message),
          onPressed: () async {
            await dataProvider.moveSelectedItems(provider.currentGroup).then(
              (result) {
                if (result) {
                  dataProvider.clearSelected();
                  dataProvider.refresh();
                }
                Navigator.pop(context);
              },
            );
          });
    });
  }

  String buildTitle(int count) {
    String title = "Moving";
    title += " $count Item";
    if (count > 1) title += "s";
    return title;
  }

  void _clearSelected(DataProvider provider) {
    provider.clearSelected();
  }

  void _selectAll(DataProvider provider) {
    provider.selectAll();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
