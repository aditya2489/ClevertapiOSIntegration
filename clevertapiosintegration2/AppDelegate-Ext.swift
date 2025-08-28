//
//  AppDelegate-Ext.swift
//  clevertapiosintegration2
//
//  Created by Aditya Waghdhare on 19/05/23.
//

import CleverTapSDK
extension AppDelegate : UNUserNotificationCenterDelegate{
    
    
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
        completionHandler([.badge, .sound, .alert])
    }
    
    
    func recordNotificationClickedEvent(){
        
        let category = UNNotificationCategory(identifier: "CTNotification", actions: [], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            guard error == nil else {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    self.center.delegate = self
                }
            }
        }
    }
}
