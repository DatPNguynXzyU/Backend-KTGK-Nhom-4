import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

enum LoginBiometric { face, fingerprint }

extension LoginBiometricInfo on LoginBiometric {
  String get label => this == LoginBiometric.face ? 'khuôn mặt' : 'vân tay';
  String get storageKey =>
      this == LoginBiometric.face ? 'face_token' : 'fingerprint_token';
  IconData get icon => this == LoginBiometric.face
      ? Icons.face_retouching_natural
      : Icons.fingerprint;
}

class FingerprintAuth {
  final LocalAuthentication _auth = LocalAuthentication();
  static bool supportsOnly(List<BiometricType> types, LoginBiometric method) {
    final wanted = method == LoginBiometric.face
        ? BiometricType.face
        : BiometricType.fingerprint;
    final other = method == LoginBiometric.face
        ? BiometricType.fingerprint
        : BiometricType.face;
    // The plugin cannot restrict the system prompt to one modality. Fail closed.
    return types.contains(wanted) &&
        !types.contains(other) &&
        !types.contains(BiometricType.iris) &&
        !types.contains(BiometricType.strong) &&
        !types.contains(BiometricType.weak);
  }

  Future<bool> available(LoginBiometric method) async =>
      supportsOnly(await _auth.getAvailableBiometrics(), method);
  Future<bool> authenticate(BuildContext context, LoginBiometric method) async {
    if (!await available(method)) {
      throw Exception(
        'Android không cho xác thực riêng bằng ${method.label} trên cấu hình thiết bị này. Hãy dùng OTP.',
      );
    }
    return _auth.authenticate(
      localizedReason: 'Dùng ${method.label} để mở ChildGuard',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}
