import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/data/providers/group_provider.dart';
import 'package:authenticator/data/providers/theme_provider.dart';
import 'package:authenticator/ui/widgets/group/add_group_button.dart';
import 'package:authenticator/ui/widgets/group/group_browser.dart';
import 'package:authenticator/ui/widgets/rename_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../notifications/snackbar_service.dart';

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
          leading: _darkModeButton(context),
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
      if (provider.selectedCount == 1)
        IconButton(
          onPressed: () => renameItem(context, provider),
          icon: Icon(Icons.drive_file_rename_outline_outlined),
          tooltip: "Rename",
        ),
      IconButton(
        onPressed: () => moveItems(context, provider),
        icon: Icon(Icons.drive_file_move_outlined),
        tooltip: "Move Selected",
      ),
      IconButton(
        onPressed: () => _selectAll(provider),
        icon: Icon(Icons.select_all_outlined),
        tooltip: "Select All",
      ),
      IconButton(
        onPressed: () => _clearSelected(provider),
        icon: Icon(Icons.clear_outlined),
        tooltip: "Clear Selected",
      ),
      SizedBox(width: 20),
      IconButton(
        onPressed: () => _deleteSelected(provider),
        icon: Icon(Icons.delete_outline),
        tooltip: "Delete Selected",
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

  void renameItem(BuildContext context, DataProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return RenameDialog();
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

  void _deleteSelected(DataProvider provider) async {
    int result = await provider.deleteSelected();
    if (result > 0) {
      String text = "item";
      if (result > 1) text += "s";
      SnackbarService.showSnackBar("$result $text deleted");
    }
  }

  void _selectAll(DataProvider provider) {
    provider.selectAll();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _darkModeButton(BuildContext context) {
    Icon icon = Theme.of(context).brightness == Brightness.light
        ? Icon(Icons.light_mode_outlined)
        : Icon(Icons.dark_mode_outlined);
    return IconButton(
      icon: icon,
      onPressed: () => context.read<ThemeProvider>().toggleTheme(),
    );
  }
}
