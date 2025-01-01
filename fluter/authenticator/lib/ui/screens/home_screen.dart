import 'package:authenticator/ui/helpers/navigation_helper.dart';
import 'package:authenticator/ui/widgets/add_auth_item_button.dart';
import 'package:authenticator/ui/widgets/auth_item/auth_item_list.dart';
import 'package:authenticator/ui/widgets/common/app_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(),
        body: AuthItemList(),
        backgroundColor: Constants.theme.dark.backgroundColor,
      floatingActionButton: AddAuthItemButton(),
    );
  }

  void addAuthItem() {
    NavigationHelper.navigateToScreen(context, Placeholder());
  }
}
