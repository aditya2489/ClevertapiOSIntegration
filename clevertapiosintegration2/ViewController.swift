//
//  ViewController.swift
//  clevertapiosintegration2
//
//  Created by Aditya Waghdhare on 14/11/22.
//

import UIKit
import CleverTapSDK
import AVFAudio

class ViewController: UIViewController ,CleverTapInboxViewControllerDelegate, CleverTapDisplayUnitDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    let locationManager = CLLocationManager()
    let sharedDefault = UserDefaults(suiteName: "group.com.biswa.Test")!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(true)
        print("CT id ---- ViewController ------",CleverTap.sharedInstance()?.profileGetID() ?? "")
        initializeLocation()
        registerAppInbox()
        initializeAppInbox()
        initialiseNativeDisplay()
        registerAppInbox()
        initializeAppInbox()
        // Do any additional setup after loading the view.
    }
    
    func initializeLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
          if let location = locations.last {
              print("----location----", location.coordinate)
              //CleverTap.sharedInstance()?.setLocation(location.coordinate)
              CleverTap.setLocation(CLLocationCoordinate2D(latitude: location.coordinate.latitude,longitude: location.coordinate.longitude))
          }
        }

    
    func initialiseNativeDisplay(){
        CleverTap.sharedInstance()?.setDisplayUnitDelegate(self)
    }
    
    
    func setUpFirebaseMessaging(){
        
            
    }
    
    @IBAction func getNativeDiplay(){
        
        CleverTap.sharedInstance()?.recordEvent("RequestNativeDisplay")
    }
    
    @IBAction func getPush(){
        
        CleverTap.sharedInstance()?.recordEvent("ShowPush")
    }
    
    @IBAction func getInApp(){
        
        CleverTap.sharedInstance()?.recordEvent("ShowInApp")
    }
    
    @IBAction func getAppInboxMesage(){
        
        CleverTap.sharedInstance()?.recordEvent("GetInboxMessage")
    }
    
    
    @IBAction func getPushTemplates(){
        
        CleverTap.sharedInstance()?.recordEvent("GetRichPush")
    }
    
    @IBAction func openappinbox(_ sender: Any) {
        print("show app inbox")
        // config the style of App Inbox Controller
                let style = CleverTapInboxStyleConfig.init()
                style.title = "App Inbox"
                style.navigationTintColor = .black
                
                if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
                    let navigationController = UINavigationController.init(rootViewController: inboxController)
                    self.present(navigationController, animated: true, completion: nil)
                }
    }
    
    
    @IBAction func loginUserButton(){
        
        print("ViewController : loginUserButton")
        print("ViewController : inside loginUser")
        let profile: Dictionary<String, String> = [
            "Name": "iPhone SE UUID 5",
            "Email": "iphone.SE5@gmail.com",
            "Identity": "55",
            "Plan type": "Gold",
        ]
        
        let identity = profile["Identity"]
        let email = profile["Email"]
        let sharedDefault = UserDefaults(suiteName: "group.com.biswa.Test")!

        sharedDefault.set(identity, forKey: "identity")
        sharedDefault.set(email, forKey: "email")

        CleverTap.sharedInstance()?.onUserLogin(profile)
    }
    
    @IBAction func profilePush(){
        
        print("ViewController : profilePush")
        
        let dob = NSDateComponents()
        dob.day = 25
        dob.month = 5
        dob.year = 1982
        let d = NSCalendar.current
        let profile: Dictionary<String, AnyObject> = [
            "Gender": "M" as AnyObject,
            "DOB": d as AnyObject,
            "Age": 37 as AnyObject,

        ]

        CleverTap.sharedInstance()?.profilePush(profile)
    }
    

    
    func messageButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]?) {
                print("App Inbox Button Tapped with custom extras: ", customExtras ?? "");
            }
    
    func displayUnitsUpdated(_ displayUnits: [CleverTapDisplayUnit]) {
           // you will get display units here
        let units:[CleverTapDisplayUnit] = displayUnits;
        for un in units {
            prepareDisplayView(un)
        }
    }
    
    func prepareDisplayView(_ un : CleverTapDisplayUnit){
        let lis : [CleverTapDisplayUnitContent] = un.contents!;
        for uni in lis {
            name.text = uni.title
            email.text = uni.message
        }
    }
}

extension ViewController{
    func registerAppInbox() {
            CleverTap.sharedInstance()?.registerInboxUpdatedBlock({
                let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
            })
        }
        
        func initializeAppInbox() {
            CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
                let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                let profileid:String! = CleverTap.sharedInstance()?.getAccountID()
                print("profile id"+profileid)
                print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
            }))
        }
}

