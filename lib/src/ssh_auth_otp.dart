import 'package:dartssh2/dartssh2.dart';
import 'dart:convert';

/// Extension to add authentication OTP simple  (2FA)
extension SSHAuthOTP on SSHClient {
  Future<void> authPasswordWithOtp(
    String username,
    String password, {
    String? otp,
  }) async {
    // Authentication with username + password
    await authPassword(username, password);

    // If the otp is given, we send it as second factor
    if (otp != null && otp.isNotEmpty) {
      final session = await startShell();
      session.write('$otp\n');
      await session.done;
    }
  }
}
