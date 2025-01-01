import 'package:authenticator/ui/widgets/group/add_group_button.dart';
import 'package:authenticator/ui/widgets/refresh_button.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarWidget({super.key, this.title = "Authenticator"});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle()),
      centerTitle: true,
      backgroundColor: Constants.theme.dark.appBarColor,
      leading: RefreshButton(),
      actions: [
        AddGroupButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
