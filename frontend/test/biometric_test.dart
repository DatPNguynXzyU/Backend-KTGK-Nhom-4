import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:phamnguyentuandat_2380614580/fingerprint.dart';

void main() {
  test('Separate keys and no cross-modality authentication', () {
    expect(
      LoginBiometric.face.storageKey,
      isNot(LoginBiometric.fingerprint.storageKey),
    );
    expect(
      FingerprintAuth.supportsOnly([BiometricType.face], LoginBiometric.face),
      isTrue,
    );
    expect(
      FingerprintAuth.supportsOnly([
        BiometricType.face,
      ], LoginBiometric.fingerprint),
      isFalse,
    );
    expect(
      FingerprintAuth.supportsOnly([
        BiometricType.fingerprint,
      ], LoginBiometric.fingerprint),
      isTrue,
    );
    for (final method in LoginBiometric.values) {
      expect(
        FingerprintAuth.supportsOnly([
          BiometricType.face,
          BiometricType.fingerprint,
        ], method),
        isFalse,
      );
      expect(
        FingerprintAuth.supportsOnly([
          BiometricType.strong,
          BiometricType.weak,
        ], method),
        isFalse,
      );
      expect(FingerprintAuth.supportsOnly([], method), isFalse);
    }
  });
}
