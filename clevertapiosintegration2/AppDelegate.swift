//
//  AppDelegate.swift
//  clevertapiosintegration2
//
//  Created by Aditya Waghdhare on 14/11/22.
//

import UIKit
import CleverTapSDK
import UserNotifications
import mParticle_Apple_SDK


@main
class AppDelegate: UIResponder, UIApplicationDelegate,CleverTapURLDelegate {
    
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options = MParticleOptions(key: "us1-881184b95665d64db3fce759331d4d23",
                                               secret: "MKpk0g_UuHhTVh7NgGC7Z_kpYT6LVOvdex7tR1z-1EjyhQg-X10Odwxh-cAOCM_u")
        options.logLevel = MPILogLevel.verbose
        MParticle.sharedInstance().start(with: options)
        
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(3)
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        CleverTap.sharedInstance()?.setInAppNotificationDelegate(Test())
        CleverTap.sharedInstance()?.setUrlDelegate(self)

        // Override point for customization after application launch.
        return true
    }
    
    public func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
        print("Handling URL: \(url!) for channel: \(channel)")
        return true
    }
        
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("%@: failed to register for remote notifications: %@", self.description, error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("%@: registered for remote notifications: %@", self.description, deviceToken.description)
    }
    
    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("%@: did receive remote notification completionhandler: %@", self.description, userInfo)
        completionHandler(UIBackgroundFetchResult.noData)
    }
    
    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        NSLog("pushNotificationTapped: customExtras: ", customExtras)
    }
    
    
    class Test : NSObject, CleverTapInAppNotificationDelegate{
        
        func inAppNotificationButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
            print("In-App Button Tapped with custom extras:", customExtras ?? "");
        }
        
    }
    
    
    func registerForPush() {
            // Register for Push notifications
            UNUserNotificationCenter.current().delegate = self
            // request Permissions
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {granted, error in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            })
        }
    
    
}



