//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit
import PortoneSDK


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var checkout: Checkout?

    var selectedProducts: [ProductDetailsObject] = []
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeChaiPay()
    
        return true
    }
    
    func initializeChaiPay() {
        
        
        UserDefaults.persistChaipayKey(key: UserDefaults.getChaipayKey ?? "bCktzybHOqyfTjrp")
        UserDefaults.persistSecretKey(key: UserDefaults.getSecretKey ?? "17fd4b860101361129e5bc3d26b7c8ff80d47f7d514e8eba66e9c95f5321b123")
        
        
        checkout = Checkout(delegate: self, environment:  UserDefaults.getEnvironment!.envType, redirectURL: "portone1://checkout", appIdentifier: "com.flutter.portone")
        checkout?.changeEnvironment(envType: UserDefaults.getDevEnv!.envType)
        
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
}

extension AppDelegate: CheckoutDelegate {
    
    func transactionErrorResponse(error: Error?) {
        print("Eror",error)
    }
    
    var viewController: UIViewController? {
        print(AppDelegate.shared.window?.rootViewController)
        return AppDelegate.shared.window?.rootViewController
    }
    
    
    func transactionResponse(response: TransactionResponse?) {
        NotificationCenter.default.post(name: NSNotification.Name("webViewResponse"), object: response)
            ("webview response", response)
    }
}
