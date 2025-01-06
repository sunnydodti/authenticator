import 'package:authenticator/ui/notifications/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/data_provider.dart';
import '../../../data/providers/group_provider.dart';

class AddGroupDialog extends StatefulWidget {
  const AddGroupDialog({super.key});

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  String title = "Create new group";
  String subTitle = "";
  GroupProvider get groupProvider =>
      Provider.of<GroupProvider>(context, listen: false);

  DataProvider get dataProvider =>
      Provider.of<DataProvider>(context, listen: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (dataProvider.currentGroup != null) {
      subTitle = " in ${dataProvider.currentGroup?.name}";
    }
  }

  defaultOnTap() => Navigator.pop(context);

  Future<bool> onConfirm() async {
    if (_formKey.currentState?.validate() ?? false) {
      int parentId = dataProvider.currentGroupId;
      int result = await groupProvider.createNewGroup(
        nameController.text,
        parentId,
      );
      String message = "Group not created";
      if (result > 0) {
        message = "Group created";
        dataProvider.refresh(notify: true);
      }

      SnackbarService.showSnackBar(message);
      defaultOnTap();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);
    // TextStyle buttonStyle =
    //     TextStyle(color: ColorHelper.getButtonTextColor(theme));
    return AlertDialog(
      // backgroundColor: ColorHelper.getTileColor(theme),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.left,
              )),
          if (subTitle.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: Text(
                subTitle,
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
              hintText: "Enter Group Name", labelText: "Group Name"),
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
          child: Text("Create"),
        ),
      ],
    );
  }
}
