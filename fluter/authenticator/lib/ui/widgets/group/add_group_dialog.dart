import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/group_provider.dart';

class AddGroupDialog extends StatefulWidget {
  const AddGroupDialog({super.key});

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  String title = "Create group";

  GroupProvider get groupProvider =>
      Provider.of<GroupProvider>(context, listen: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (groupProvider.currentGroup != null) {
      title += " in ${groupProvider.currentGroup?.name}";
    }
  }

  Future<bool> onConfirm() async {
    await groupProvider.createNewGroup("test group", isLeaf: true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    defaultOnTap() {
      Navigator.pop(context);
    }

    ThemeData theme = Theme.of(context);
    // TextStyle buttonStyle =
    //     TextStyle(color: ColorHelper.getButtonTextColor(theme));
    return AlertDialog(
      // backgroundColor: ColorHelper.getTileColor(theme),
      title: Text(title),
      content: Text("hi"),
      actions: <Widget>[
        TextButton(
            child: Text("Cancel"),
            onPressed: () {
              defaultOnTap();
            }),
        TextButton(
          child: Text("Create"),
          onPressed: () async {
            await onConfirm();
            defaultOnTap();
          },
        ),
      ],
    );
  }
}
