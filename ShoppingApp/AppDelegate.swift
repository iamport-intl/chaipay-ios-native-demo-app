//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit
import ChaiPayPaymentSDK
import React
import Sodium

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var checkout: Checkout?
    var addRatingView: RCTRootView?
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
        
        UserDefaults.persistChaipayKey(key: "bCktzybHOqyfTjrp")
        UserDefaults.persistSecretKey(key: "17fd4b860101361129e5bc3d26b7c8ff80d47f7d514e8eba66e9c95f5321b123")
        
        //        UserDefaults.persistChaipayKey(key: "aiHKafKIbsdUJDOb")
        //        UserDefaults.persistSecretKey(key: "2601efeb4409f7027da9cbe856c9b6b8b25f0de2908bc5322b1b352d0b7eb2f5")
        
    
        
        
        let bytes = stringToBytes("58bfb06252b5f9270750c67c92c6fbceed5a6615a25c4952591e2d0da465e13d")
        
        
        let sodium = Sodium()
        let y = "58bfb06252b5f9270750c67c92c6fbceed5a6615a25c4952591e2d0da465e13d".bytes
        let customMessage = "4242424242424242".bytes
        let cvv = "123".bytes
        guard let hash = sodium.genericHash.hash(message: y) else { return }
        guard let hashOfSize32Bytes = sodium.genericHash.hash(message: hash, outputLength: 32) else { return }
        

        
        let bytes1 = sodium.box.seal(message: customMessage, recipientPublicKey: bytes ?? hashOfSize32Bytes)
        
        let dataString = sodium.utils.bin2hex(bytes1!)
        print("card num", dataString ?? "Siri")
        let bytes2 = sodium.box.seal(message: cvv, recipientPublicKey: bytes ?? hashOfSize32Bytes)
        
        let dataString1 = sodium.utils.bin2hex(bytes2!)
        print("Required num", dataString1 ?? "Siri")
        
        
        UserDefaults.persistDevEnv(envObj: DevEnvObject(index: 0, environmentTitle: "Dev", envType: "dev"))
        UserDefaults.persistEnv(environmentObject: EnvObject(index: 0, environmentTitle: "Sandbox", envType: "sandbox"))
        guard let selectedEnvironment = UserDefaults.getSelectedEnvironment else {
            return
        }
        
        
        checkout = Checkout(environmentType: .dev, redirectURL: "chaiport://checkout", secretKey: UserDefaults.getSecretKey!, chaiPayKey: UserDefaults.getChaipayKey!, languageCode: "", delegate: self, environment: "sandbox", currency: "THB")
        
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
    
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return RCTLinkingManager.application(app, open: url, options: options)
    }
    
    // Universal Links
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        return RCTLinkingManager.application(application, continue: userActivity, restorationHandler: restorationHandler)
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
