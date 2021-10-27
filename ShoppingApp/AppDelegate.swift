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
        checkout = Checkout(environmentType: .dev, redirectURL: "chaipay://", secretKey: "2601efeb4409f7027da9cbe856c9b6b8b25f0de2908bc5322b1b352d0b7eb2f5", chaiPayKey: "aiHKafKIbsdUJDOb", languageCode: "", delegate: self)
        UserDefaults.persistMobileNumber(number: "+918341469169")
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
