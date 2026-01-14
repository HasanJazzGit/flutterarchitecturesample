import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Setup method channel for secret key
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    let channel = FlutterMethodChannel(
      name: "native/keys",
      binaryMessenger: controller.binaryMessenger
    )
    
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getSecretKey" {
        // Get secret key from C++ implementation (same as Android)
        // In production, this should be stored securely or generated dynamically
        // Consider:
        // 1. Storing in iOS Keychain
        // 2. Generating from device-specific properties
        // 3. Retrieving from secure server
        let key = SecurityUtilsBridge.getSecretKey()
        let keyPrefix = key.prefix(5)
        print("[Security] Secret key retrieved from C++: \(keyPrefix)...")
        result(key)
      } else {
        print("[Security] Unknown method: \(call.method)")
        result(FlutterMethodNotImplemented)
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
