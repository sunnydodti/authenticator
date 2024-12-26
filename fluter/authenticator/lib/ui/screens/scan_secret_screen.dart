import 'package:authenticator/models/otp_config.dart';
import 'package:authenticator/services/otp/otp_service.dart';
import 'package:authenticator/ui/helpers/platform_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:logger/logger.dart';

import '../../tools/logger.dart';
import '../helpers/navigation_helper.dart';

class ScanSecretScreen extends StatefulWidget {
  const ScanSecretScreen({super.key});

  @override
  State<ScanSecretScreen> createState() => _ScanSecretScreenState();
}

class _ScanSecretScreenState extends State<ScanSecretScreen> {
  final isCameraSupported = PlatformHelper.isCameraSupported;
  final OtpService otpService = OtpService();
  final Logger logger = Log.logger;

  Code? result;
  String scanStatus = "Scanning For Qr Code";

  String config = "";

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
            if (result != null) buildResult(),
            Text(scanStatus),
            Text("config: $config"),
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
            height: 300,
            child: ReaderWidget(
              onScan: _onScanSuccess,
              onScanFailure: _onScanFailure,
              toggleCameraIcon: Icon(Icons.swap_horizontal_circle_outlined),
              galleryIcon: Icon(Icons.photo_library_outlined),
            ));
  }

  void _onScanSuccess(Code? code) {
    setState(() {
      result = code;
      scanStatus = "Scan Successful";
    });
    bool isValid = false;
    try {
      OTPConfig otpConfig = otpService.parseOTPConfig("${code?.text}");
      print(otpConfig.toString());
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
