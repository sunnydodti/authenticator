import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/data_provider.dart';
import '../../data/providers/group_provider.dart';
import '../../enums/list_item_type.dart';
import '../../models/list_item.dart';
import '../notifications/snackbar_service.dart';

class RenameDialog extends StatefulWidget {
  const RenameDialog({super.key});

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  String title = "Rename";
  String type = "";
  late ListItem selected;
  GroupProvider get groupProvider =>
      Provider.of<GroupProvider>(context, listen: false);

  DataProvider get dataProvider =>
      Provider.of<DataProvider>(context, listen: false);

  @override
  void initState() {
    final selectedItems = dataProvider.getSelectedItems();
    selected = selectedItems[0];
    if (selected.type == ListItemType.authItem) {
      type = "Account";
      nameController.text = selected.authItem!.name;
    }

    if (selected.type == ListItemType.group) {
      type = "Group";
      nameController.text = selected.group!.name;
    }
    super.initState();
  }

  defaultOnTap() => Navigator.pop(context);

  Future<bool> onConfirm() async {
    if (_formKey.currentState?.validate() ?? false) {
      int result = 0;
      if (type == "Group") {
        result = await groupProvider.renameGroup(
            selected.group!, nameController.text);
      } else {
        result = await dataProvider.renameAuthItem(
            selected.authItem!, nameController.text);
      }
      String message = "$type not renamed";
      if (result > 0) {
        message = "$type renamed";
        dataProvider.clearSelected();
        dataProvider.refresh(notify: true);
      }

      SnackbarService.showSnackBar(message);
      defaultOnTap();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.left,
              )),
          SizedBox(
            width: double.infinity,
            child: Text(
              type.toLowerCase(),
              textScaler: TextScaler.linear(.7),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: nameController,
          decoration: InputDecoration(
              hintText: "Enter $type Name", labelText: "$type Name"),
          validator: (value) {
            if (value == null || value.isEmpty) return 'name is required';
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text("Cancel"),
            onPressed: () {
              defaultOnTap();
            }),
        TextButton(
          onPressed: onConfirm,
          child: Text("Rename"),
        ),
      ],
    );
  }
}
