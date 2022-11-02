import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'navillela_background_location_platform_interface.dart';

/// An implementation of [NavillelaBackgroundLocationPlatform] that uses method channels.
class MethodChannelNavillelaBackgroundLocation extends NavillelaBackgroundLocationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('navillela_background_location');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
