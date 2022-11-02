
import 'navillela_background_location_platform_interface.dart';

class NavillelaBackgroundLocation {
  Future<String?> getPlatformVersion() {
    return NavillelaBackgroundLocationPlatform.instance.getPlatformVersion();
  }
}
