import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/auth_item.dart';
import '../../../services/otp/totp.dart';

class AuthItemTile extends StatefulWidget {
  final AuthItem authItem;

  const AuthItemTile({super.key, required this.authItem});

  @override
  AuthItemTileState createState() => AuthItemTileState();
}

class AuthItemTileState extends State<AuthItemTile> {
  late Timer _timer;
  late String _otpCode;
  late TOTP totp = TOTP("", digits: 6);

  @override
  void initState() {
    super.initState();
    _generateOtp();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateProgress();
    });

    totp = TOTP(widget.authItem.secret);
    _otpCode = totp.now();
  }

  void _generateOtp() {
    setState(() {
      _otpCode = totp.now();
    });
  }

  double _getProgress() {
    int currentSeconds = DateTime.now().second;
    double progress = (currentSeconds % 30) / 30;
    return 1 - progress;
  }

  void _updateProgress() {
    setState(() {
      if (_getProgress() > 0.94) {
        _generateOtp();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text("dfvdfj");
    return ListTile(
      title: Text(widget.authItem.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('OTP: $_otpCode', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: _getProgress(),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _generateOtp,
      ),
    );
  }
}
