//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit
import ChaiPayPaymentSDK
//import React


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var checkout: Checkout?
    //var addRatingView: RCTRootView?
    var selectedProducts: [ProductDetailsObject] = []
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeChaiPay()
    
        return true
    }
    
    func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
    
    
    func initializeChaiPay() {
        
       
        
        //        UserDefaults.persistChaipayKey(key: "aiHKafKIbsdUJDOb")
        //        UserDefaults.persistSecretKey(key: "2601efeb4409f7027da9cbe856c9b6b8b25f0de2908bc5322b1b352d0b7eb2f5")
        
        
    
        
        
        UserDefaults.persistDevEnv(envObj: DevEnvObject(index: 0, environmentTitle: "Dev", envType: "dev"))
        UserDefaults.persistEnv(environmentObject: EnvObject(index: 0, environmentTitle: "Sandbox", envType: "sandbox"))
        
        UserDefaults.persistChaipayKey(key: UserDefaults.getChaipayKey ?? "bCktzybHOqyfTjrp")
        UserDefaults.persistSecretKey(key: UserDefaults.getSecretKey ?? "17fd4b860101361129e5bc3d26b7c8ff80d47f7d514e8eba66e9c95f5321b123")
        guard let selectedEnvironment = UserDefaults.getSelectedEnvironment else {
            return
        }
        
        checkout = Checkout(delegate: self, environment: "sandbox")
        checkout?.changeEnvironment(envType: "dev")
        
        if let mobileNumber = UserDefaults.getMobileNumber {
            UserDefaults.removeMobileNumber()
            UserDefaults.removeAuthorisationToken()
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
    
    
//    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      //  return RCTLinkingManager.application(app, open: url, options: options)
//    }
//    
//    // Universal Links
//    func application(
//        _ application: UIApplication,
//        continue userActivity: NSUserActivity,
//        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
//    ) -> Bool {
//        //return RCTLinkingManager.application(application, continue: userActivity, restorationHandler: restorationHandler)
//    }
}

extension AppDelegate: CheckoutDelegate {
    
    func transactionErrorResponse(error: Error?) {
        print("Eror",error)
    }
    
    var viewController: UIViewController? {
        return AppDelegate.shared.window?.rootViewController
    }
    
    
    func transactionResponse(response: TransactionResponse?) {
        NotificationCenter.default.post(name: NSNotification.Name("webViewResponse"), object: response)
            ("webview response", response)
    }
}
