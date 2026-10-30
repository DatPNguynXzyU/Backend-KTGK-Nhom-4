import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:phamnguyentuandat_2380614580/fingerprint.dart';

void main() {
  test('Android strength-only and mixed enrollment can open system prompt', () {
    for (final method in LoginBiometric.values) {
      expect(FingerprintAuth.canOffer([BiometricType.strong], method), isTrue);
      expect(FingerprintAuth.canOffer([BiometricType.weak], method), isTrue);
      expect(
        FingerprintAuth.canOffer([
          BiometricType.face,
          BiometricType.fingerprint,
        ], method),
        isTrue,
      );
      expect(FingerprintAuth.canOffer([], method), isFalse);
    }
  });
  test('Explicit modalities and separate storage keys', () {
    expect(
      FingerprintAuth.canOffer([BiometricType.face], LoginBiometric.face),
      isTrue,
    );
    expect(
      FingerprintAuth.canOffer([
        BiometricType.fingerprint,
      ], LoginBiometric.fingerprint),
      isTrue,
    );
    expect(
      FingerprintAuth.canOffer([
        BiometricType.face,
      ], LoginBiometric.fingerprint),
      isFalse,
    );
    expect(
      FingerprintAuth.canOffer([
        BiometricType.fingerprint,
      ], LoginBiometric.face),
      isFalse,
    );
    expect(LoginBiometric.values.map((m) => m.storageKey).toSet().length, 3);
  });
}
