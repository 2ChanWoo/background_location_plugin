import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:navillela_background_location/location.dart';

import 'navillela_background_location_platform_interface.dart';

enum Services {
  start_location_service,
  stop_location_service;
}

/// An implementation of [NavillelaBackgroundLocationPlatform] that uses method channels.
class MethodChannelNavillelaBackgroundLocation extends NavillelaBackgroundLocationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('navillela_background_location');

  @override
  Future<bool?> startLocationService(double distanceFilter) async {
    Map<String, dynamic> args = {
      'distanceFilter': distanceFilter
    };
    return await methodChannel.invokeMethod<bool?>(Services.start_location_service.name, args);
  }

  @override
  Future<bool?> stopLocationService() async {
    await methodChannel.invokeMethod(Services.stop_location_service.name);
  }

  /// Register a function to recive location updates as long as the location
  /// service has started
  @override
  getLocationUpdates(Function(Location?) callback) {
    // add a handler on the channel to recive updates from the native classes
    methodChannel.setMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'location') {

        //위치 측정에 실패하여 locationManager - didFailWithError 가 호출될 경우
        if(methodCall.arguments == null) {
          callback(null);
          return;
        }

        var locationData = Map.from(methodCall.arguments);
        // Call the user passed function
        callback(
          Location(
              latitude: locationData['latitude'],
              longitude: locationData['longitude'],
              altitude: locationData['altitude'],
              accuracy: locationData['accuracy'],
              bearing: locationData['bearing'],
              speed: locationData['speed'],
              time: locationData['time'],
              isMock: locationData['is_mock']),
        );
      }
    });
  }

  /*
  *   static setAndroidNotification(
      {String? title, String? message, String? icon}) async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('set_android_notification',
          <String, dynamic>{'title': title, 'message': message, 'icon': icon});
    } else {
      //return Promise.resolve();
    }
  }

  static setAndroidConfiguration(int interval) async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('set_configuration', <String, dynamic>{
        'interval': interval.toString(),
      });
    } else {
      //return Promise.resolve();
    }
  }

  /// Get the current location once.
  Future<Location> getCurrentLocation() async {
    var completer = Completer<Location>();

    var _location = Location();
    await getLocationUpdates((location) {
      _location.latitude = location.latitude;
      _location.longitude = location.longitude;
      _location.accuracy = location.accuracy;
      _location.altitude = location.altitude;
      _location.bearing = location.bearing;
      _location.speed = location.speed;
      _location.time = location.time;
      completer.complete(_location);
    });

    return completer.future;
  }




}
  * */

}
