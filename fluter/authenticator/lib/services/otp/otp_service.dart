abstract class OtpService {
  String generateOtp(String secret);
}

class TOTPService implements OtpService {
  @override
  String generateOtp(String secret) {
    return "otp";
  }
}
