import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:crypto/crypto.dart';

class TOTP {
  final String secret;
  final int digits;
  final int interval;

  TOTP(this.secret, {this.digits = 6, this.interval = 30});

  String now() {
    int timeCounter = _timeCode(DateTime.now());
    return _generateOTP(timeCounter);
  }

  String _generateOTP(int input) {
    if (input < 0) {
      throw ArgumentError("input must be a positive integer");
    }

    if (secret.isEmpty) return "";

    Uint8List secretBytes = _byteSecret();
    Uint8List counterBytes = _intToByteString(input);

    Hmac hmac = Hmac(sha1, secretBytes);
    Digest hmacHash = hmac.convert(counterBytes);

    List<int> hash = hmacHash.bytes;
    int offset = hash[hash.length - 1] & 0xF;

    int code = ((hash[offset] & 0x7F) << 24) |
        ((hash[offset + 1] & 0xFF) << 16) |
        ((hash[offset + 2] & 0xFF) << 8) |
        (hash[offset + 3] & 0xFF);

    int otp = code % (pow(10, digits).toInt());
    return otp.toString().padLeft(digits, '0');
  }

  int _timeCode(DateTime time) {
    int unixTime = time.millisecondsSinceEpoch ~/ 1000;
    return unixTime ~/ interval;
  }

  Uint8List _byteSecret() {
    String secretWithPadding = secret;
    int missingPadding = secret.length % 8;
    if (missingPadding != 0) {
      secretWithPadding += '=' * (8 - missingPadding);
    }

    return base32.decode(secretWithPadding);
  }

  Uint8List _intToByteString(int i, {int padding = 8}) {
    List<int> result = [];
    while (i != 0) {
      result.add(i & 0xFF);
      i >>= 8;
    }

    result = List.from(result.reversed);
    while (result.length < padding) {
      result.insert(0, 0);
    }

    return Uint8List.fromList(result);
  }
}
