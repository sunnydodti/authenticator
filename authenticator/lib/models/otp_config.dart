import '../enums/otp_type.dart';

class OTPConfig {
  final OTPType type; // TOTP or HOTP
  final String issuer;
  final String account;
  final String secret;
  final String algorithm;
  final int digits;
  final int period; // Only used for TOTP
  final int? counter; // Only used for HOTP

  OTPConfig({
    required this.type,
    required this.issuer,
    required this.account,
    required this.secret,
    this.algorithm = 'SHA1',
    this.digits = 6,
    this.period = 30, // Default for TOTP, ignored for HOTP
    this.counter, // Only applicable to HOTP
  });

  @override
  String toString() {
    return 'OTPConfig(type: ${type.name}, issuer: $issuer, account: $account, secret: $secret, algorithm: $algorithm, digits: $digits, period: $period, counter: $counter)';
  }
}
