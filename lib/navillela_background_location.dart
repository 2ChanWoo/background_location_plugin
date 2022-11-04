
import 'package:navillela_background_location/location.dart';

import 'navillela_background_location_platform_interface.dart';

/**
 * referenced by 'background_location 0.8.1'
 * */

class NavillelaBackgroundLocation {
  static Future<bool?> startLocationService({double distanceFilter = 0.0 /*bool forceAndroidLocationManager = false*/}) {
    return NavillelaBackgroundLocationPlatform.instance.startLocationService(distanceFilter);
  }

  static Future<bool?> stopLocationService() {
    return NavillelaBackgroundLocationPlatform.instance.stopLocationService();
  }

  static getLocationUpdates(Function(Location?) location) {
    NavillelaBackgroundLocationPlatform.instance.getLocationUpdates((location));
  }
}
