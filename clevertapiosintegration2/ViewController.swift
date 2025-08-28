//
//  ViewController.swift
//  clevertapiosintegration2
//
//  Created by Aditya Waghdhare on 14/11/22.
//

import UIKit
import CleverTapSDK
import AVFAudio
import mParticle_Apple_SDK

class ViewController: UIViewController ,CleverTapInboxViewControllerDelegate, CleverTapDisplayUnitDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    let locationManager = CLLocationManager()
    let sharedDefault = UserDefaults(suiteName: "group.com.biswa.Test")!
    
    let customerIdField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Enter your id"
            tf.borderStyle = .roundedRect
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
        }()

        let emailField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Enter your email"
            tf.borderStyle = .roundedRect
            tf.keyboardType = .emailAddress
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(true)
        print("CT id ---- ViewController ------",CleverTap.sharedInstance()?.profileGetID() ?? "")
        initializeLocation()
        registerAppInbox()
        initializeAppInbox()
        initialiseNativeDisplay()
        view.addSubview(customerIdField)
        view.addSubview(emailField)
        NSLayoutConstraint.activate([
            customerIdField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            customerIdField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customerIdField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            emailField.topAnchor.constraint(equalTo: customerIdField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                   
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loginwithMPIDCT()
                }

        // Do any additional setup after loading the view.
    }
    
    func initializeLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let profile: Dictionary<String, AnyObject> = [
            "userId": "10925" as AnyObject
        ]
        
        CleverTap.sharedInstance()?.profilePush(profile)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if let location = locations.last {
            print("----location----", location.coordinate)
            //CleverTap.sharedInstance()?.setLocation(location.coordinate)
            CleverTap.setLocation(CLLocationCoordinate2D(latitude: location.coordinate.latitude,longitude: location.coordinate.longitude))
            CleverTap.sharedInstance()?.notifyApplicationLaunched(withOptions:nil)
        }
        
    }
    
    
    func initialiseNativeDisplay(){
        CleverTap.sharedInstance()?.setDisplayUnitDelegate(self)
    }
    
    @IBAction func CAL(_ sender: Any) {
        
        logoutFromMParticle()
        //CleverTap.sharedInstance()?.notifyApplicationLaunched(withOptions:nil)
    }
    
    func setUpFirebaseMessaging(){
        
        
    }
    
    @IBAction func getNativeDiplay(){
        
        let event = MPEvent(name: "Test MP Event Check", type: .navigation)

        // (Optional) Add attributes
        event?.customAttributes = [
            "screen": "HomePage",
            "button_color": "green",
            "user_role": "premium"
        ]

        // Log the event
        if let event = event {
            MParticle.sharedInstance().logEvent(event)
        }
        
        CleverTap.sharedInstance()?.recordEvent("InAppActivity")
    }
    
    @IBAction func getPush(){
        
        CleverTap.sharedInstance()?.recordEvent("ShowPush")
    }
    
    @IBAction func getInApp(){
        
        CleverTap.sharedInstance()?.recordEvent("ShowInApp")
    }
    
    @IBAction func getAppInboxMesage(){
        
        CleverTap.sharedInstance()?.recordEvent("GetInboxMessage")
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        
        // call didFinishLaunchWithOptions ... why?
        appDelegate?.registerForPush()
    }
    
    
    @IBAction func getPushTemplates(){
        
        CleverTap.sharedInstance()?.recordEvent("GetRichPush")
        //clearUDS()
        //hitPurchase()
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
        let id = customerIdField.text ?? ""
        let email = emailField.text ?? ""
        
        let profile: Dictionary<String, String> = [
            "Name": "IPhone simulator2",
            "Email": email,
            "Identity": id,
            "Plan type": "Gold",
        ]
       
        let sharedDefault = UserDefaults(suiteName: "group.com.biswa.Test")!
        
        sharedDefault.set(id, forKey: "identity")
        sharedDefault.set(email, forKey: "email")
        
        print("Printing profile")
        print(profile)
        
        loginToMParticle(profile:profile)
        
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
    
    
    func hitPurchase() {
        
        
        var productItems = [[String : Any]]()
        
        for i in 1...5 {
            
            let item = [
                
                "ItemID" : i,
                "ItemName": "p",
                "Price": 999,
                "LineStatus":"Success"
            ] as [String : Any]
            productItems.append(item)
        }
        
        // Prepare ecommerce parameters
        
        let productDetails: [String: Any] = [
            
            "TransactionID"            : "567",
            "Affiliation"              : "ENBD",
            "Currency"                 : "AED",
            "Value"                    : 756,
            "Tax"                      : 5,
            "noOfGiftcards"            : 3,
            "Status"                   : "Redeemed",
            "OrderName"                : "Gift_Card_Purchase"
        ]
        
        CleverTap.sharedInstance()?.recordChargedEvent(withDetails: productDetails, andItems: productItems)
        
    }
    
    func clearUDS()
    {
        guard let accId = CleverTap.sharedInstance()?.config.accountId else {
            return
        }
        let fileName = "{{App bundle identifier}}}.plist"
        let appDir = NSSearchPathForDirectoriesInDomains(.preferencePanesDirectory, .userDomainMask, true).last
        let filePath = "\(appDir!)/\(fileName)"
        if FileManager.default.fileExists(atPath: filePath) {
            try! FileManager.default.removeItem(atPath: filePath)
        }
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key.contains("WizRocket"){
                
                if(key != "WizRocketdevice_token" || key != "WizRocketfirstTime"){
                    defaults.removeObject(forKey: key)
                }
            }
        }
        defaults.synchronize()
    
    }
    
    func loginToMParticle(profile: Dictionary<String, String>) {
        let identityRequest = MPIdentityApiRequest()
        identityRequest.customerId = profile["Identity"]
        identityRequest.email = profile["Email"]

        MParticle.sharedInstance().identity.login(identityRequest) { result, error in
            if let error = error {
                print("Login error: \(error)")
            } else {
                print("Login success: \(String(describing: result?.user))")
                self.loginwithMPIDCT()
            }
        }
    }
    
    func loginwithMPIDCT(){
        if let currentUser = MParticle.sharedInstance().identity.currentUser {
            let mpidString = currentUser.userId.stringValue
            let profile: [String: String] = [
                "Identity": mpidString
            ]
            print(mpidString)
            
            CleverTap.sharedInstance()?.onUserLogin(profile)
        }
    }
    
    
    func logoutFromMParticle() {
            let request = MPIdentityApiRequest.withEmptyUser()
            
            MParticle.sharedInstance().identity.logout(request) { result, error in
                if let user = result?.user {
                    print("Logged out user with MPID: \(user.userId)")
                    self.loginwithMPIDCT()
                } else if let error = error {
                    print("Logout failed: \(error.localizedDescription)")
                }
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

