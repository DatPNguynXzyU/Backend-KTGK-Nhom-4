import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

enum LoginBiometric { face, fingerprint, device }

extension LoginBiometricInfo on LoginBiometric {
  String get label => switch (this) {
    LoginBiometric.face => 'khuôn mặt',
    LoginBiometric.fingerprint => 'vân tay',
    LoginBiometric.device => 'sinh trắc học thiết bị',
  };
  String get storageKey => switch (this) {
    LoginBiometric.face => 'face_token',
    LoginBiometric.fingerprint => 'fingerprint_token',
    LoginBiometric.device => 'device_biometric_token',
  };
  IconData get icon => this == LoginBiometric.face
      ? Icons.face_retouching_natural
      : Icons.fingerprint;
}

class FingerprintAuth {
  final LocalAuthentication _auth = LocalAuthentication();
  // Android may report strength categories instead of individual modalities.
  // This only checks whether to offer the system prompt, not which sensor it uses.
  static bool canOffer(List<BiometricType> types, LoginBiometric method) {
    if (method == LoginBiometric.device) return types.isNotEmpty;
    final wanted = method == LoginBiometric.face
        ? BiometricType.face
        : BiometricType.fingerprint;
    return types.contains(wanted) ||
        types.contains(BiometricType.strong) ||
        types.contains(BiometricType.weak);
  }

  Future<bool> available(LoginBiometric method) async =>
      canOffer(await _auth.getAvailableBiometrics(), method);
  Future<bool> authenticate(BuildContext context, LoginBiometric method) async {
    if (!await available(method)) {
      throw Exception(
        'Chưa có sinh trắc học phù hợp được đăng ký. Hãy kiểm tra cài đặt bảo mật điện thoại.',
      );
    }
    return _auth.authenticate(
      localizedReason:
          'Mở ChildGuard bằng sinh trắc học. Hệ điều hành quyết định dùng khuôn mặt hoặc vân tay.',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}
