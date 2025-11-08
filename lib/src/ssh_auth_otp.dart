import 'package:dartssh2/dartssh2.dart';
import 'dart:convert';
/*
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
*/

import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';

/// Estensione per autenticazione SSH con password e OTP (2FA)
extension SSHAuthOTP on SSHClient {
  /// Autenticazione SSH con OTP opzionale (2FA)
  Future<void> authPasswordWithOtp(
    String username,
    String password, {
    String? otp,
  }) async {
    // Fase 1: autenticazione standard con username + password
    await authenticate(
      SSHPasswordAuthenticator(
        username: username,
        password: password,
      ),
    );

    // Fase 2: se serve OTP, attendiamo il prompt e lo inviamo
    if (otp != null && otp.isNotEmpty) {
      // Apriamo una sessione SSH
      final session = await execute('echo "ready_for_otp"');
      await session.done;

      // Inviamo l'OTP
      final otpSession = await execute('echo $otp');
      await otpSession.done;
    }
  }
}
