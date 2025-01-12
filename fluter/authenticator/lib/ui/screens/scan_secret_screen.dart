import 'package:authenticator/data/providers/auth_item_provider.dart';
import 'package:authenticator/data/providers/data_provider.dart';
import 'package:authenticator/models/auth_item.dart';
import 'package:authenticator/models/otp_config.dart';
import 'package:authenticator/services/otp/otp_service.dart';
import 'package:authenticator/ui/helpers/platform_helper.dart';
import 'package:authenticator/ui/notifications/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../tools/logger.dart';
import '../helpers/navigation_helper.dart';

class ScanSecretScreen extends StatefulWidget {
  const ScanSecretScreen({super.key});

  @override
  State<ScanSecretScreen> createState() => _ScanSecretScreenState();
}

class _ScanSecretScreenState extends State<ScanSecretScreen> {
  AuthItemProvider get authItemProvider =>
      Provider.of<AuthItemProvider>(context, listen: false);

  DataProvider get dataProvider =>
      Provider.of<DataProvider>(context, listen: false);

  final isCameraSupported = PlatformHelper.isCameraSupported;
  final OtpService otpService = OtpService();
  final Logger logger = Log.logger;

  Code? result;
  String scanStatus = "Scanning For Qr Code";

  int groupId = Constants.db.group.defaultGroupId;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan"),
        centerTitle: true,
        leading: SafeArea(
            child: BackButton(
                onPressed: () => NavigationHelper.navigateBack(context))),
      ),
      body: Card(
        child: Column(
          children: [
            buildScanner(),
            // if (result != null) buildResult(),
            Text(scanStatus),
            Row()
          ],
        ),
      ),
    );
  }

  Widget buildScanner() {
    return (!isCameraSupported)
        ? Center(child: Text("Camera Not Supported"))
        : SizedBox(
            width: 300,
            height: 350,
            child: ReaderWidget(
              onScan: _onScanSuccess,
              onScanFailure: _onScanFailure,
              actionButtonsAlignment: Alignment.bottomCenter,
              toggleCameraIcon: Icon(Icons.swap_horizontal_circle_outlined),
              galleryIcon: Icon(Icons.photo_library_outlined),
            ));
  }

  addAuthItemFromConfig(OTPConfig config) async {
    AuthItem authItem = AuthItem(
        name: config.account,
        serviceName: config.issuer,
        secret: config.secret,
        code: "",
        groupId: groupId);

    int result = await authItemProvider.createAuthItem(authItem);
    String message = 'Secret saved successfully';
    if (result < 0) message = "Couldn't add account";

    SnackbarService.showSnackBar(message);
    dataProvider.refresh(notify: true);

    if (mounted) Navigator.pop(context);
  }

  void _onScanSuccess(Code? code) async {
    setState(() {
      result = code;
      scanStatus = "Scan Successful";
    });
    try {
      OTPConfig otpConfig = otpService.parseOTPConfig("${code?.text}");
      if (!otpService.isValidSecret(otpConfig.secret)) {
        SnackbarService.showSnackBar('Invalid QR Code');
        return;
      }
      await addAuthItemFromConfig(otpConfig);
    } catch (e, stackTrace) {
      logger.e("Error parsing uri: $e - \n$stackTrace");
      setState(() {
        result = code;
        scanStatus = "QR Not Supported";
      });
    }
  }

  void _onScanFailure(Code? code) {
    String message = "Scan Failed";
    if (code?.error?.isNotEmpty == true) message = "Error: ${code?.error}";
    setState(() {
      scanStatus = message;
    });
  }

  Widget buildResult() {
    return SelectableText("${result?.text}");
  }
}
