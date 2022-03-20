//
//  AppDelegate.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let defaults = UserDefaults.standard


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (defaults.object(forKey: "isFirstLaunch") == nil) {
            // Configuring the settings with the bundle
            configureSettingsBundle()
            // Add date for initial launch
            defaults.set(NSDate(), forKey: "Initial Launch")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // How to configure upon launch with the values from
    // preferences to settings.bundle
    // https://www.logisticinfotech.com/blog/setting-bundle-ios-application/
    func configureSettingsBundle() {
        print("everything configured")
                guard let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension:"bundle") else {
                print("Settings.bundle not found")
                return;
            }
            
            guard let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")) else {
                print("Root.plist not found in settings bundle")
                return
            }
            
            guard let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: AnyObject]] else {
                print("Root.plist has invalid format")
                return
            }
            
            var defaultsToRegister = [String: AnyObject]()
            for pref in preferences {
                if let key = pref["Key"] as? String, let val = pref["DefaultValue"] {
                    print("\(key)==> \(val)")
                    defaultsToRegister[key] = val
                }
            }
            defaults.register(defaults: defaultsToRegister)
        }
}

