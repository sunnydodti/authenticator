import 'dart:io';

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
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

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

  // new
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result2;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    zx.startCameraProcessing();
  }

  @override
  void dispose() {
    super.dispose();
    zx.stopCameraProcessing();
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
            _buildScanner(),
            // if (result2 != null) buildResult(),
            Text(scanStatus),
            Expanded(child: Row())
          ],
        ),
      ),
    );
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

  Widget buildResult() {
    return SelectableText("${result2?.code}");
  }

  Widget _buildScanner() {
    return Expanded(
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        formatsAllowed: [BarcodeFormat.qrcode],
        overlay: QrScannerOverlayShape(),
        
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      setState(() {
        result2 = scanData;
        scanStatus = "Scan Successful";
      });
      try {
        OTPConfig otpConfig = otpService.parseOTPConfig("${scanData.code}");
        if (!otpService.isValidSecret(otpConfig.secret)) {
          SnackbarService.showSnackBar('Invalid QR Code');
          controller.resumeCamera();
          return;
        }
        await addAuthItemFromConfig(otpConfig);
      } catch (e, stackTrace) {
        logger.e("Error parsing uri: $e - \n$stackTrace");

        setState(() {
          result2 = scanData;
          scanStatus = "QR Not Supported";
        });
        controller.resumeCamera();
      }
    });

  }
}
