import 'package:authenticator/data/providers/auth_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_group_dialog.dart';

class AddGroupButton extends StatelessWidget {
  const AddGroupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthItemProvider>(
      builder: (context, value, child) {
        return IconButton(
          onPressed: () => showAddGroupForm(context),
          icon: Icon(Icons.create_new_folder_outlined),
          tooltip: "Add Group",
        );
      },
    );
  }

  void showAddGroupForm(BuildContext context) {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AddGroupDialog();
      },
    );
  }
}
