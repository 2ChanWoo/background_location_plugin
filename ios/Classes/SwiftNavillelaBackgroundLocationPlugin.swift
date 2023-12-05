import Flutter
import UIKit
import CoreLocation

enum services : String {
    case start_location_service
    case stop_location_service
}

public class SwiftNavillelaBackgroundLocationPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    
    static var locationManager : CLLocationManager?
    static var channel : FlutterMethodChannel?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "navillela_background_location", binaryMessenger: registrar.messenger())
    let instance = SwiftNavillelaBackgroundLocationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      SwiftNavillelaBackgroundLocationPlugin.locationManager = CLLocationManager()
      SwiftNavillelaBackgroundLocationPlugin.locationManager?.delegate = self
      SwiftNavillelaBackgroundLocationPlugin.locationManager?.requestAlwaysAuthorization()
      SwiftNavillelaBackgroundLocationPlugin.locationManager?.allowsBackgroundLocationUpdates = true
      
      if #available(iOS 11.0, *) {
          SwiftNavillelaBackgroundLocationPlugin.locationManager?.showsBackgroundLocationIndicator = true
      }
      
      SwiftNavillelaBackgroundLocationPlugin.locationManager?.pausesLocationUpdatesAutomatically = false
      
      switch call.method {
      case services.start_location_service.rawValue:
          let args = call.arguments as? Dictionary<String, Any>
          let distanceFilter = args?["distance_filter"] as? Double
          SwiftNavillelaBackgroundLocationPlugin.locationManager?.distanceFilter = distanceFilter ?? 0
          SwiftNavillelaBackgroundLocationPlugin.locationManager?.startUpdatingLocation()
          result(true)
      case services.stop_location_service.rawValue:
          SwiftNavillelaBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: services.stop_location_service.rawValue)
          SwiftNavillelaBackgroundLocationPlugin.locationManager?.stopUpdatingLocation()
          result(true)
      default:
          result(false)
      }
  }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
        var ellipsoidalAltitude : Optional<Double>
       
        if #available(iOS 15, *) {
            ellipsoidalAltitude = locations.last?.ellipsoidalAltitude
        } else {
            ellipsoidalAltitude = nil
        }
        
        var location = [
            "speed": locations.last!.speed,
            "altitude": locations.last!.altitude,
            "ellipsoidalAltitude": ellipsoidalAltitude,
            "horizontalAccuracy": locations.last?.horizontalAccuracy,
            "verticalAccuracy": locations.last?.verticalAccuracy,
            "courseAccuracy": nil,
//            "sourceInformation": (UIDevice.current.systemVersion >= "15.0") ? locations.last?.sourceInformation : nil,
            "latitude": locations.last!.coordinate.latitude,
            "longitude": locations.last!.coordinate.longitude,
            "accuracy": locations.last!.horizontalAccuracy,
            "bearing": locations.last!.course,
            "time": locations.last!.timestamp.timeIntervalSince1970 * 1000,
            "is_mock": false,
        ] as [String : Any?]
        if #available(iOS 15, *) {
            location["isProducedByAccessory"] = locations.last?.sourceInformation?.isProducedByAccessory
            location["isSimulatedBySoftware"] = locations.last?.sourceInformation?.isSimulatedBySoftware
        }

        SwiftNavillelaBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SwiftNavillelaBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: nil)
    }
}
