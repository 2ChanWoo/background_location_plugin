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
    
    override init() {
        debugPrint("SwiftNavillelaBackgroundLocationPlugin init()")
        SwiftNavillelaBackgroundLocationPlugin.locationManager = CLLocationManager()
        
        // requestWhenInUseAuthorization 을 먼저 해 주어야 함.
        // 바로 requestAlwaysAuthorization 을 날리면, While using app 까지가 최선인데 문제는 While using app 상태어도 Always 가 반환이 됨.
        // ㄴ> https://developer.apple.com/documentation/corelocation/cllocationmanager/1620551-requestalwaysauthorization#3578736
//        SwiftNavillelaBackgroundLocationPlugin.locationManager?.requestWhenInUseAuthorization()
//        SwiftNavillelaBackgroundLocationPlugin.locationManager?.requestAlwaysAuthorization()
        SwiftNavillelaBackgroundLocationPlugin.locationManager?.allowsBackgroundLocationUpdates = true
        /// iOS 16.4 16.5 16.6 => background location fetch issue.
        /// ㄴ> https://developer.apple.com/forums/thread/726945
//           let distanceFilter = args?["distance_filter"] as? Double
        SwiftNavillelaBackgroundLocationPlugin.locationManager?.distanceFilter = kCLDistanceFilterNone
        
        SwiftNavillelaBackgroundLocationPlugin.locationManager?.showsBackgroundLocationIndicator = true
                
        //SwiftNavillelaBackgroundLocationPlugin.locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        //SwiftNavillelaBackgroundLocationPlugin.locationManager?.activityType = CLActivityType.automotiveNavigation // other 가 기본값.
        SwiftNavillelaBackgroundLocationPlugin.locationManager?.pausesLocationUpdatesAutomatically = false
        
        super.init()
        SwiftNavillelaBackgroundLocationPlugin.locationManager?.delegate = self // super.init() 아래에 선언해야 함
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "navillela_background_location", binaryMessenger: registrar.messenger())
    let instance = SwiftNavillelaBackgroundLocationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case services.start_location_service.rawValue:
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = locations.last!.timestamp
        let dateString = dateFormatter.string(from: date)
        
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
            "time": dateString,
            "is_mock": false,
        ] as [String : Any?]
        if #available(iOS 15, *) {
            location["isProducedByAccessory"] = locations.last?.sourceInformation?.isProducedByAccessory
            location["isSimulatedBySoftware"] = locations.last?.sourceInformation?.isSimulatedBySoftware
        }

        SwiftNavillelaBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("SwiftNavillelaBackgroundLocationPlugin/didFailWithError :: \(error))")
        SwiftNavillelaBackgroundLocationPlugin.channel?.invokeMethod("didFailWithError", arguments: error)
    }
    
    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("SwiftNavillelaBackgroundLocationPlugin/locationManagerDidPauseLocationUpdates :: ")
        SwiftNavillelaBackgroundLocationPlugin.channel?.invokeMethod("locationManagerDidPauseLocationUpdates", arguments: nil)
    }
}
