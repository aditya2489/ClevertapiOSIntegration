//
//  NotificationViewController.swift
//  PushTemplateIOS
//
//  Created by Aditya Waghdhare on 10/04/23.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CTNotificationContent

class NotificationViewController: CTNotificationViewController {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}
