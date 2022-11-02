import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navillela_background_location/navillela_background_location_method_channel.dart';

void main() {
  MethodChannelNavillelaBackgroundLocation platform = MethodChannelNavillelaBackgroundLocation();
  const MethodChannel channel = MethodChannel('navillela_background_location');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
