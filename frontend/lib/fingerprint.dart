import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

/// Fail closed when the platform cannot identify fingerprint specifically.
class FingerprintAuth {
  final LocalAuthentication _auth = LocalAuthentication();
  Future<bool> available() async {
    final types = await _auth.getAvailableBiometrics();
    return types.contains(BiometricType.fingerprint) &&
        !types.contains(BiometricType.face) &&
        !types.contains(BiometricType.iris);
  }

  Future<bool> authenticate(BuildContext context) async {
    if (!await available()) {
      throw Exception(
        'Không xác nhận được phương thức chỉ dùng vân tay. Hãy đăng nhập bằng OTP.',
      );
    }
    return _auth.authenticate(
      localizedReason: 'Dùng vân tay để mở phiên ChildGuard',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}
