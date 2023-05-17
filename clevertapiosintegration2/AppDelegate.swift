//
//  AppDelegate.swift
//  clevertapiosintegration2
//
//  Created by Aditya Waghdhare on 14/11/22.
//

import UIKit
import CleverTapSDK
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CleverTap.autoIntegrate()
        registerForPush()
        CleverTap.setDebugLevel(3)
        CleverTap.sharedInstance()?.setInAppNotificationDelegate(Test())
        // Override point for customization after application launch.
        return true
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
    
    // MARK: UISceneSession Lifecycle
    
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NSLog("%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo)
        //CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        //CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NSLog("%@: will present notification: %@", self.description, notification.request.content.userInfo)
        
        //let sharedDefault = UserDefaults(suiteName: "group.com.biswa.Test")!
        
        //let identity = sharedDefault.string(forKey: "identity") ?? ""
        //let email = sharedDefault.string(forKey: "email") ?? ""
        
        //if(identity == "" && email == ""){
        //    print("CT id ----------",CleverTap.sharedInstance()?.profileGetID() ?? "")
        //    CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: notification.request.content.userInfo)
        //}
        //CleverTap.sharedInstance()?.handleNotification(withData: notification.request.content.userInfo, openDeepLinksInForeground: true)
        completionHandler([.badge, .sound, .alert])
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
    
    
}



