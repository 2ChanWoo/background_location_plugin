import Flutter
import UIKit

public class SwiftNavillelaBackgroundLocationPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "navillela_background_location", binaryMessenger: registrar.messenger())
    let instance = SwiftNavillelaBackgroundLocationPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
