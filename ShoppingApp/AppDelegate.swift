//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit
import ChaiPayPaymentSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var checkout: Checkout?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeChaiPay()
        return true
    }
    
    func initializeChaiPay() {
        guard let selectedEnvironment = UserDefaults.getSelectedEnvironment else {
            return
        }
        
        checkout = Checkout(environmentType: .dev, redirectURL: "chaipay://", secretKey: selectedEnvironment.secretKey, chaiPayKey: selectedEnvironment.key, languageCode: "", delegate: self)
        
        if let mobileNumber = UserDefaults.getMobileNumber {
            
        } else {
            UserDefaults.persistMobileNumber(number: "+918341469169")
        }
        
        if let langCode = UserDefaults.getLanguageCode {}
        else {
            UserDefaults.persistAppLanguageCode(number: "en")
            UserDefaults.persistAppLanguage(langCode: "en")
        }
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


}

extension AppDelegate: CheckoutDelegate {
    
    func transactionErrorResponse(_ error: Error?) {
        print("Eror",error)
    }
    
    var viewController: UIViewController? {
        return AppDelegate.shared.window?.rootViewController
    }
    
    func transactionResponse(_ webViewResponse: WebViewResponse?) {
        NotificationCenter.default.post(name: NSNotification.Name("webViewResponse"), object: webViewResponse)
        print("webview response", webViewResponse)
    }
}
