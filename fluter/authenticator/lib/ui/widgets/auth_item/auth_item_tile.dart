import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/auth_item.dart';
import '../../../services/otp/totp.dart';
import 'otp_progress_bar.dart';

class AuthItemTile extends StatefulWidget {
  final AuthItem authItem;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const AuthItemTile({
    super.key,
    required this.authItem,
    required this.isSelected,
    required this.onSelect,
    required this.onToggle,
    required this.onTap,
  });

  @override
  AuthItemTileState createState() => AuthItemTileState();
}

class AuthItemTileState extends State<AuthItemTile> {
  late Timer _timer;
  late String _otpCode;
  late TOTP totp = TOTP("", digits: 6);

  final int epochInterval = 30000;

  @override
  void initState() {
    super.initState();
    totp = TOTP(widget.authItem.secret);
    _generateOtp();

    final int currentEpochTime = DateTime.now().millisecondsSinceEpoch;
    final int nextEpochTime =
        ((currentEpochTime ~/ epochInterval) + 1) * epochInterval;
    final Duration initialDelay =
        Duration(milliseconds: nextEpochTime - currentEpochTime);

    _timer = Timer(initialDelay, () {
      _generateOtp();
      _timer = Timer.periodic(Duration(milliseconds: epochInterval), (_) {
        _generateOtp();
      });
    });
  }

  void _generateOtp() {
    setState(() {
      _otpCode = totp.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentEpochTime = DateTime.now().millisecondsSinceEpoch;
    final int elapsedTime = currentEpochTime % epochInterval;

    Color color = Colors.transparent;
    if (widget.isSelected) color = Colors.blue.withAlpha(50);
    return Container(
      color: color,
      child: ListTile(
        selected: widget.isSelected,
        onLongPress: widget.onSelect,
        onTap: widget.onTap,
        title: Text(widget.authItem.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OTP: $_otpCode', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            OtpProgressBar(
              backgroundColor: Colors.white,
              progressColor: Colors.blue,
              totalDuration: Duration(milliseconds: epochInterval),
              elapsedDuration: Duration(milliseconds: elapsedTime),
            ),
          ],
        ),
        trailing: !widget.isSelected
            ? null
            : IconButton(
                onPressed: widget.onToggle,
                icon: const Icon(Icons.check_box),
              ),
      ),
    );
  }
}
