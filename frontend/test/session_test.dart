import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phamnguyentuandat_2380614580/api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Lock preserves saved enrollment; logout removes it but keeps appearance',
    () async {
      final saved = <String, String>{
        'device_biometric_token': 'session',
        'appearance': 'theme',
      };
      const channel = MethodChannel(
        'plugins.it_nomads.com/flutter_secure_storage',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            final args = Map<String, dynamic>.from(call.arguments);
            if (call.method == 'delete') saved.remove(args['key']);
            if (call.method == 'read') return saved[args['key']];
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      final api = Api()..token = 'session';
      api.lock();
      expect(api.token, isNull);
      expect(await Api.storage.read(key: 'device_biometric_token'), 'session');
      await api.logout();
      expect(await Api.storage.read(key: 'device_biometric_token'), isNull);
      expect(saved['appearance'], 'theme');
    },
  );
}
