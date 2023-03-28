//
//  CheckoutReactModule.swift
//  PackageShield
//
//  Created by Sireesha Neelapu on 06/12/21.
//

import Foundation
import React


class CheckoutReactModule: NSObject {
  static let sharedInstance = CheckoutReactModule()
    var bridge: RCTBridge?

    func createBridgeIfNeeded() -> RCTBridge {
      if bridge == nil {
        bridge = RCTBridge.init(delegate: self, launchOptions: nil)
      }
      return bridge!
    }
    func viewForModule(_ moduleName: String,  initialProperties: [String : Any]?) -> RCTRootView {
      let viewBridge = createBridgeIfNeeded()
      let rootView: RCTRootView = RCTRootView(
        bridge: viewBridge,
        moduleName: moduleName,
        initialProperties: initialProperties)
      return rootView
    }
}

extension CheckoutReactModule: RCTBridgeDelegate {

 func sourceURL(for bridge: RCTBridge!) -> URL! {
      #if DEBUG
     let x =  RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
     return x
     #else
     return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
     #endif
//     return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
   //return URL(string: "http://192.168.0.101:8081/index.bundle?platform=ios")
 }
}



//class ReactNativeBridge {
//    let bridge: RCTBridge
//
//    init() {
//        bridge = RCTBridge(delegate: ReactNativeBridgeDelegate(), launchOptions: nil)
//    }
//}
//
//class ReactNativeBridgeDelegate: NSObject, RCTBridgeDelegate {
//
//    func sourceURL(for bridge: RCTBridge!) -> URL! {
//         #if DEBUG
//        let x = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
//        return x
//        #else
//        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
//        #endif
//   //     return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackResource: nil)
//      //return URL(string: "http://192.168.0.101:8081/index.bundle?platform=ios")
//    }
//}
//
//
//class CheckoutReactModule: UIViewController {
//    var innerview: RCTRootView!
//    init(moduleName: String, bridge: RCTBridge) {
//        super.init(nibName: nil, bundle: nil)
//        innerview = RCTRootView(bridge: bridge,
//                           moduleName: moduleName,
//                           initialProperties: nil)
//        self.view = innerview
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
