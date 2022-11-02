import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'navillela_background_location_method_channel.dart';

abstract class NavillelaBackgroundLocationPlatform extends PlatformInterface {
  /// Constructs a NavillelaBackgroundLocationPlatform.
  NavillelaBackgroundLocationPlatform() : super(token: _token);

  static final Object _token = Object();

  static NavillelaBackgroundLocationPlatform _instance = MethodChannelNavillelaBackgroundLocation();

  /// The default instance of [NavillelaBackgroundLocationPlatform] to use.
  ///
  /// Defaults to [MethodChannelNavillelaBackgroundLocation].
  static NavillelaBackgroundLocationPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NavillelaBackgroundLocationPlatform] when
  /// they register themselves.
  static set instance(NavillelaBackgroundLocationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
