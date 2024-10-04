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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
