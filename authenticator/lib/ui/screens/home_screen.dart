import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/ui/helpers/navigation_helper.dart';
import 'package:authenticator/ui/notifications/snackbar_service.dart';
import 'package:authenticator/ui/widgets/add_auth_item_button.dart';
import 'package:authenticator/ui/widgets/auth_item/auth_item_list.dart';
import 'package:authenticator/ui/widgets/auth_item/otp_progress_bar.dart';
import 'package:authenticator/ui/widgets/breadcrumbs.dart';
import 'package:authenticator/ui/widgets/common/app_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_install/pwa_install.dart';

import '../widgets/common/mobile_wrapper.dart';

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
    final int currentEpochTime = DateTime.now().millisecondsSinceEpoch;
    final int epochInterval = 30000; // 30 seconds for TOTP
    final int elapsedTime = currentEpochTime % epochInterval;

    return PopScope(
      canPop: checkCanPop(),
      onPopInvokedWithResult: handelPop,
      child: MobileWrapper(
        child: Scaffold(
          appBar: AppBarWidget(),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Breadcrumbs(),
              OtpProgressBar(
                backgroundColor: Colors.white,
                progressColor: Colors.blue,
                totalDuration: Duration(milliseconds: epochInterval),
                elapsedDuration: Duration(milliseconds: elapsedTime),
              ),
              AuthItemList(),
              if (kIsWeb)
                Column(
                  children: [
                    Text('This is a Demo PWA',
                        style: TextStyle(color: Colors.red.shade400)),
                    Text('Data will not be saved on refresh',
                        style: TextStyle(color: Colors.red.shade400)),
                  ],
                ),
              if (PWAInstall().installPromptEnabled)
                ElevatedButton(
                  onPressed: () {
                    PWAInstall().promptInstall_();
                  },
                  child: const Text('Install PWA'),
                ),
            ],
          ),
          floatingActionButton: AddAuthItemButton(),
        ),
      ),
    );
  }

  void handelPop(didPop, result) {
    if (dataProvider.isAtRoot) {
      setState(() => dataProvider.canPop = true);
      SnackbarService.showSnackBar('Press back again to exit');
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
