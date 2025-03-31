import 'package:authenticator/models/otp_config.dart';

import '../../enums/otp_type.dart';
import 'totp.dart';

class OtpService {
  String generateOtp(String secret) {
    return "otp";
  }

  OTPConfig parseOTPConfig(String uri) {
    if (!uri.startsWith('otpauth://totp/') &&
        !uri.startsWith('otpauth://hotp/')) {
      throw ArgumentError('Invalid OTP URI');
    }

    final OTPType type =
        uri.contains('otpauth://totp/') ? OTPType.totp : OTPType.hotp;

    final uriWithoutScheme = uri
        .replaceFirst('otpauth://totp/', '')
        .replaceFirst('otpauth://hotp/', '');

    final splitUri = uriWithoutScheme.split('?');
    final accountInfo = splitUri[0];
    final queryParams =
        Uri.parse('otpauth://totp/?${splitUri[1]}').queryParameters;

    final accountParts = accountInfo.split(':');
    String account = '';
    String issuer = '';
    if (accountParts.length == 2) {
      issuer = Uri.decodeComponent(accountParts[0]);
      account = Uri.decodeComponent(accountParts[1]);
    } else {
      account = Uri.decodeComponent(accountParts[0]);
      issuer = queryParams['issuer'] ?? '';
    }

    final secret = queryParams['secret'];
    final algorithm = queryParams['algorithm'] ?? 'SHA1';
    final digits = int.tryParse(queryParams['digits'] ?? '6') ?? 6;

    final period = type == OTPType.totp
        ? int.tryParse(queryParams['period'] ?? '30') ?? 30
        : null;
    final counter = type == OTPType.hotp
        ? int.tryParse(queryParams['counter'] ?? '0') ?? 0
        : null;

    if (secret == null || secret.isEmpty) {
      throw ArgumentError('Secret is missing from the URI');
    }

    return OTPConfig(
      type: type,
      issuer: issuer,
      account: account,
      secret: secret,
      algorithm: algorithm,
      digits: digits,
      period: period ?? 30,
      counter: counter,
    );
  }

  bool isValidSecret(String secret) {
    TOTP totp = TOTP(secret, digits: 6);
    try {
      totp.now();
    } on FormatException catch (e, stackTrace) {
      return false;
    }
    return true;
  }
}
