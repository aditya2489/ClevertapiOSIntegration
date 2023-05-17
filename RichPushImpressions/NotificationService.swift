//
//  NotificationService.swift
//  RichPushImpressions
//
//  Created by Aditya Waghdhare on 18/03/23.
//

import UserNotifications
import CTNotificationService
import CleverTapSDK

class NotificationService: CTNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        //Add Multiinstance part here and create a clevertap instance based on the region
        
        
        CleverTap.setDebugLevel(3)
        
        let sharedDefault = UserDefaults(suiteName: "group.com.biswa.Test")!
        
        let identity = sharedDefault.string(forKey: "identity") ?? ""
        let email = sharedDefault.string(forKey: "email") ?? ""
        
        if(identity != "" && email != ""){
            let profile: Dictionary<String, Any> = [
                "Identity": identity,
                "Email": email,]
            CleverTap.sharedInstance()?.onUserLogin(profile)
            
        }
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
        
        
        super.didReceive(request, withContentHandler: contentHandler)
    }
    
 
    
}
