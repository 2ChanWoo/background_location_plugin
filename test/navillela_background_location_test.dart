import 'package:flutter_test/flutter_test.dart';
import 'package:navillela_background_location/navillela_background_location.dart';
import 'package:navillela_background_location/navillela_background_location_platform_interface.dart';
import 'package:navillela_background_location/navillela_background_location_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNavillelaBackgroundLocationPlatform 
    with MockPlatformInterfaceMixin
    implements NavillelaBackgroundLocationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NavillelaBackgroundLocationPlatform initialPlatform = NavillelaBackgroundLocationPlatform.instance;

  test('$MethodChannelNavillelaBackgroundLocation is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNavillelaBackgroundLocation>());
  });

  test('getPlatformVersion', () async {
    NavillelaBackgroundLocation navillelaBackgroundLocationPlugin = NavillelaBackgroundLocation();
    MockNavillelaBackgroundLocationPlatform fakePlatform = MockNavillelaBackgroundLocationPlatform();
    NavillelaBackgroundLocationPlatform.instance = fakePlatform;
  
    expect(await navillelaBackgroundLocationPlugin.getPlatformVersion(), '42');
  });
}
