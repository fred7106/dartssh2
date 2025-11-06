import 'package:dartssh2/dartssh2.dart';

extension SSHClientOtpExtension on SSHClient {
  /// Autenticazione SSH con password + OTP
  ///
  /// Usa questa funzione quando il server richiede 2FA.
  /// [otpToken] è il codice OTP già generato dal client Flutter.
  Future<void> authPasswordWithOtp(
    String username,
    String password,
    String otpToken,
  ) async {
    // Prima autenticazione con password
    await authPassword(username, password);

    // Poi invio del token OTP (keyboard-interactive)
    await authKeyboardInteractive(
      username,
      onPrompt: (prompts) async {
        if (prompts.isNotEmpty) {
          return [otpToken];
        }
        return [];
      },
    );
  }
}
