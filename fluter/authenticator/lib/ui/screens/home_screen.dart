import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/ui/helpers/navigation_helper.dart';
import 'package:authenticator/ui/widgets/add_auth_item_button.dart';
import 'package:authenticator/ui/widgets/auth_item/auth_item_list.dart';
import 'package:authenticator/ui/widgets/breadcrumbs.dart';
import 'package:authenticator/ui/widgets/common/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataProvider get dataProvider =>
      Provider.of<DataProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: checkCanPop(),
      onPopInvokedWithResult: handelPop,
      child: Scaffold(
        appBar: AppBarWidget(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Breadcrumbs(),
            AuthItemList(),
          ],
        ),
        backgroundColor: Constants.theme.dark.backgroundColor,
        floatingActionButton: AddAuthItemButton(),
      ),
    );
  }

  void handelPop(didPop, result) {
    if (dataProvider.isAtRoot) {
      setState(() => dataProvider.canPop = true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Press back again to exit')));
      return;
    }

    dataProvider.popCurrentGroup(refreshData: true);
  }

  void addAuthItem() {
    NavigationHelper.navigateToScreen(context, Placeholder());
  }

  checkCanPop() {
    return dataProvider.canPop;
  }
}
