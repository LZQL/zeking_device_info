import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zeking_device_info/zeking_device_info.dart';

void main() {
  const MethodChannel channel = MethodChannel('zeking_device_info');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
//    expect(await ZekingDeviceInfo.platformVersion, '42');
  });
}
