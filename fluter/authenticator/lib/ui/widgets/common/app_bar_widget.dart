import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/ui/widgets/group/add_group_button.dart';
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
                "${provider.selectedItems.values.where((element) => element == true).length}",
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () => _clearSelected(provider),
                  icon: Icon(Icons.drive_file_move_outlined)),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.select_all_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.clear_outlined)),
            ],
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

  void _clearSelected(DataProvider provider) {
    provider.clearSelected();
  }

  void _selectAll(DataProvider provider) {
    provider.selectAll();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
