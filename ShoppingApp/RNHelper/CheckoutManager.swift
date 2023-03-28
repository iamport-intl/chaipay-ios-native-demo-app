//
//  CheckoutManager.swift
//  PackageShield
//
//  Created by Sireesha Neelapu on 07/12/21.
//

import Foundation
import React
import ChaiPayPaymentSDK
import CryptoKit
import WebKit

@objc(CheckoutManager)
class CheckoutManager: RCTEventEmitter {
  
    public static var shared:CheckoutManager?
    
    var selectedEnvironment: EnvironmentObject? {
        return UserDefaults.getSelectedEnvironment
    }
    
    var themeColor = UserDefaults.getThemeColor.code
    override init() {
        super.init()
        CheckoutManager.shared = self
        
    }

    @objc
    override static func requiresMainQueueSetup() -> Bool {
      return true
    }
    
    override func supportedEvents() -> [String]! {
      return [ "showWalletElement", "showCardInputElement" , "showPaymentMethodsElement", "showMobileAuthElement", "showSavedCardsElement","showPayNowElement", "showCartListElement", "showCartSummaryElement", "showTransactionStatusElement", "showCheckoutElement",   "AddRatingManagerEvent", "showBasicUI", "setInitialData", "ShowPaymentMethods"]
    }

    @objc
    func setInitialData(chaipayKey: NSString, env: NSString, environment: NSString, secretKey: NSString, redirectURL: NSString, currency: String) {
        DispatchQueue.main.async {
            self.sendEvent(withName: "setInitialData", body: ["chaipayKey": chaipayKey, "env": env, "environment": environment, "secretKey": secretKey, "redirectURL": redirectURL, "currency": currency ])
        }
    }
    func prepareConfig() -> TransactionRequestModal {
        let merchantOrderId = self.getMerchantOrderId()
        let bilAddress = BillingAddressModal(city: "VND", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
        let billingDetails = BillingDetailsModal(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: "+918341469169" , billingAddress: bilAddress)
        
        let shippingAddress = ShippingAddressModal(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
        
        let shippingDetails = ShippingDetailsModal(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
        
        var orderDetails: [OrderDetailsModal] = []
        var totalAmount = 0.0
        for details in AppDelegate.shared.selectedProducts {
            let product = OrderDetailsModal(id: details.id ?? "", name: details.title ?? "", price: details.price ?? 0.0, quantity: 1, imageUrl: details.imageName ?? "")
            totalAmount += (details.price ?? 0.0)!
            orderDetails.append(product)
        }
        
        let merchantDetails = MerchantDetailsModal(name: "Downy", logo: "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg", backUrl: "https://demo.chaipay.io/checkout.html", promoCode: "Downy350", promoDiscount: 35000, shippingCharges: 0.0)
        let payload = TransactionRequestModal(chaipayKey: "NPSkZZYefGyKvBxi", merchantDetails: merchantDetails, paymentChannel: "VTCPAY", paymentMethod: "VTCPAY_ALL", merchantOrderId: merchantOrderId, amount: 50010, currency: "VND", signatureHash: "", billingAddress: billingDetails, shippingAddress: shippingDetails, orderDetails: orderDetails, successURL: "https://test-checkout.chaipay.io/success.html", failureURL: "https://test-checkout.chaipay.io/failure.html", redirectURL: "chaiport://checkout", countryCode: "VN", environment: "sandbox")
        let signatureHash = self.createHash(amount: "\(payload.amount)", chaipayKey: payload.chaipayKey, currency: payload.currency, failureURL: payload.failureURL, merchantOrderId: payload.merchantOrderId, successURL: payload.successURL)
        payload.signatureHash = signatureHash
        
        return payload
    }
    func getMerchantOrderId() -> String {
        return "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))"
    }
    
    func createHash(amount: String?, chaipayKey: String?, currency: String?, failureURL: String?, merchantOrderId: String?, successURL: String?) -> String {
        var message = ""
        message =
        "amount=\(amount ?? "")" +
        "&client_key=\(chaipayKey!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&currency=\(currency!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&failure_url=\(failureURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&merchant_order_id=\(merchantOrderId!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&success_url=\(successURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        
        let secretString = "6c8d964e7d472076eae7beb0a1f5b2b81c0afbb479307a211029ace597656957"
        let key = SymmetricKey(data: secretString.data(using: .utf8)!)
        
        let signature = HMAC<SHA256>.authenticationCode(for: message.data(using: .utf8)!, using: key)
        let base64 =  Data(signature).base64EncodedString()
        
        return base64
    }
    
    func getSingaturehash(merchantOrderId: String) -> String {
        return "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))"
    }
    
    func createJWTToken() -> String {
        
        struct Header: Encodable {
            let alg = "HS256"
            let typ = "JWT"
        }
        func generateCurrentTimeStamp (extraTime: Int = 0) -> Int {
            let currentTimeStamp = Date().timeIntervalSince1970 + TimeInterval(extraTime)
            return Int(currentTimeStamp)
        }
        let payload = Payload(iss: "CHAIPAY", sub: "NPSkZZYefGyKvBxi", iat: generateCurrentTimeStamp(), exp: generateCurrentTimeStamp(extraTime: 10000))
        
        let secret = "6c8d964e7d472076eae7beb0a1f5b2b81c0afbb479307a211029ace597656957"
        let privateKey = SymmetricKey(data: secret.data(using: .utf8)!)

        let headerJSONData = try! JSONEncoder().encode(Header())
        let headerBase64String = headerJSONData.urlSafeBase64EncodedString()

        let payloadJSONData = try! JSONEncoder().encode(payload)
        let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

        let toSign = (headerBase64String + "." + payloadBase64String).data(using: .utf8)!

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
        return token
        
    }
    
    @objc
    func sendPaymentMethodsUIEvent() {
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        let walletStyles = WalletElementStyle(themeColor: "#FFFFFF", nameFontSize: 14, nameFontWeight: "200", imageWidth: nil, imageHeight: nil, imageResizeMode: nil, checkBoxHeight: 30, headerTitle: "header", headerTitleFont: nil, headerTitleWeight: nil, headerImage: nil, headerImageWidth: nil, headerImageHeight: nil, headerImageResizeMode: nil, searchPlaceHolder: "place", shouldShowSearch: true, payNowButtonCornerRadius: 15)
        let style = PaymentMethodsStyle(headerTitle: "Paying options", fontSize: 15, fontWeight: "500", headerFontSize: 14, headerFontWeight: "500", headerColor: "red", themeColor: UserDefaults.getThemeColor.code, removeBorder: true, walletViewStyles: walletStyles, cardStyles: nil, transactionStyles: nil, layout: UserDefaults.getLayout.code)
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showPaymentMethodsElement", body:
                            ["payload": json, "style": styleJson])
            
        }
    }
    
    @objc
    func sendWalletUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let style = WalletElementStyle(themeColor: themeColor, nameFontSize: 14, nameFontWeight: nil, imageWidth: nil, imageHeight: nil, imageResizeMode: nil, checkBoxHeight: 50, headerTitle: "Esha", headerTitleFont: 17, headerTitleWeight: nil, headerImage: nil, headerImageWidth: nil, headerImageHeight: nil, headerImageResizeMode: nil, searchPlaceHolder: nil, shouldShowSearch: true, payNowButtonCornerRadius: 25)
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showWalletElement", body: ["payload": json, "style": styleJson])
        }
    }
    
    
    @objc
    func sendCardInputUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let style = CardInputStyle(headerFontWeight: "500", fontSize: nil, fontWeight: nil, showSaveForLater: false, themeColor: themeColor, borderRadius: 15, nameFontSize: 12, payNowButtonText: "Proceed", nameFontWeight: nil, buttonBorderRadius: 15)
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showCardInputElement", body: ["payload": json, "style": styleJson])
        }
    }
    //"#003030"
    
    @objc
    func sendSavedCardsUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let style = PaymentMethodsStyle(headerTitle: "Paying options", fontSize: 15, fontWeight: "500", headerFontSize: 14, headerFontWeight: "500", headerColor: "red", themeColor: themeColor, removeBorder: true, walletViewStyles: nil, cardStyles: nil, transactionStyles: nil, layout: 1)
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showSavedCardsElement", body:
                            ["payload": json, "showAuthenticationFlow": true, "style": styleJson])
        }
    }
    
    @objc
    func sendCartListUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let style = CartStyle(height: nil, nameFontSize: nil, nameFontWeight: nil, descriptionSize: 18, descriptionFontWeight: "600", amountTitle: "Amount", amountFont: nil, amountFontWeight: nil, deliveryTitle: nil, deliveryFont: nil, deliveryFontWeight: nil, summaryTitle: nil, summaryFont: nil, summaryFontWeight: nil, borderRadius: nil, borderWidth: nil, headerText: nil, orderSummaryText: nil, headerTextColor: nil, headerFont: nil, headerFontWeight: nil, removeBorder: nil, showNetPayable: nil, borderColor: nil, themeColor: "#000000", deliveryColor: "black", summaryColor: "black", amountColor: "black", backgroundColor: "black", layout: 1)
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showCartListElement", body:
                            ["payload": json, "deliveryAmount": "500", "totalAmount": "50010", "style": styleJson])
        }
    }
    
    @objc
    func sendCartSummaryUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let style = CartStyle(height: nil, nameFontSize: nil, nameFontWeight: "500", descriptionSize: nil, descriptionFontWeight: nil, amountTitle: "12344", amountFont: 15, amountFontWeight: nil, deliveryTitle: "DeLEIVEy", deliveryFont: 12, deliveryFontWeight: nil, summaryTitle: "sUMMary", summaryFont: 15, summaryFontWeight: nil, borderRadius: 10, borderWidth: nil, headerText: "header", orderSummaryText: "Order", headerTextColor: nil, headerFont: nil, headerFontWeight: nil, removeBorder: nil, showNetPayable: nil, borderColor: nil, themeColor: themeColor, deliveryColor: nil, summaryColor: nil, amountColor: nil, backgroundColor: nil)
        
        
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showCartSummaryElement", body:
                            ["payload": json, "deliveryAmount": "500", "totalAmount": "50010", "style": styleJson])
        }
    }
    
    @objc
    func sendTransactionStatusUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        let style = TransactionStatusStyle(themeColor: "#030303", backgroundColor: "transparent", borderRadius: 25, nameFontSize: 15, nameFontWeight: "400", buttonBorderRadius: 25)
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showTransactionStatusElement", body: ["payload": json, "style": styleJson])
        }
    }
    
    @objc
    func sendCheckoutUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let style = PaymentMethodsStyle(headerTitle: "Paying options", fontSize: 15, fontWeight: "500", headerFontSize: 14, headerFontWeight: "500", headerColor: "red", themeColor:  UserDefaults.getThemeColor.code, removeBorder: true, walletViewStyles: nil, cardStyles: nil, transactionStyles: nil, layout: UserDefaults.getLayout.code)
        let styleData = try! jsonEncoder.encode(style)
        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        let JWTToken = createJWTToken()
        
        DispatchQueue.main.async {
            self.sendEvent(withName: "showCheckoutElement", body:
                                  ["payload": json , "JWT": JWTToken, "style": styleJson])
        }
    }
    
    @objc
    func sendPayNowUIEvent(_ status: Bool = false) {
        
        let payload = self.prepareConfig()
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(payload)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
//        let style = PayNowStyle(themeColor: themeColor, textFontSize: 18, textFontWeight: "200", textColor: nil, borderRadius: 12, height: 50, width: 120, text: "Pay Now")
//        let styleData = try! jsonEncoder.encode(style)
//        let styleJson = String(data: styleData, encoding: String.Encoding.utf8)
        
        
        DispatchQueue.main.async {
            
            self.sendEvent(withName: "showPayNowElement", body: ["payload": json])
        }
    }
    
//    func returnRNView() -> RCTRootView {
//        return CheckoutReactModule().viewForModule(
//            "CheckoutApp",
//            initialProperties: nil)
//    }
    func presentTheRNVC(parentView: UIViewController) {
        let vc = UIViewController()
        if let view = AppDelegate.shared.addRatingView {
            view.sizeFlexibility = .widthAndHeight
            view.frame = CGRect(x: 0, y: 250, width: 150, height: 250)
            
            parentView.view.addSubview(view)
        }
        
        
       
//        let view = CheckoutReactModule.sharedInstance.viewForModule(
//            "CheckoutApp",
//            initialProperties: nil)
//            view.frame = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
//            vc.view.addSubview(view)
//
//
//        parentView.present(vc, animated: true, completion: nil)
        
    }
    
    func addTheRNVC(parentView: UIViewController) {
        let vc = UIViewController()
        if let view = AppDelegate.shared.addRatingView {
            view.frame = CGRect(x: 0, y: 10, width: 1, height: 1)
            

            parentView.view.addSubview(view)
        }
        
    }
    
    //Callbacks
    
  @objc func dismissPresentedViewController(_ reactTag: NSString) {
    print(":::::: SIRI ::::::")
    DispatchQueue.main.async {
        AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
  }
    
    
    @objc func getNonTokenizationATMDetails(_ reactTag: NSString) {
      print(":::::: SIRI ::::::")
      DispatchQueue.main.async {
                
          AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
      
    @objc func getNonTokenizationCreditDetails(_ reactTag: NSString) {
      print(":::::: SIRI ::::::")
      DispatchQueue.main.async {
                
          AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
     
    @objc func getTokenizationCardDetails(_ reactTag: NSString) {
      print(":::::: SIRI ::::::")
      DispatchQueue.main.async {
                
          AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
    
    @objc func getTransactionStatus(_ reactTag: NSString) {
      print(":::::: SIRI ::::::")
        
      DispatchQueue.main.async {
                
          AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
    @objc func getNewCardDetails(_ reactTag: NSString) {
      print(":::::: SIRI ::::::")
      DispatchQueue.main.async {
                
          AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
    @objc func getSavedCardsData(_ reactTag: NSString) {
      print(":::::: SIRI ::::::")
      DispatchQueue.main.async {
                
          AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
    @objc func getSavedCardsSelectedData(_ reactTag: NSString) {
      print(":::::: SIRI ::::::")
      DispatchQueue.main.async {
                
          AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
      }
    }
    
    @objc func getSelectedWallet(_ message: String) -> Void {
      // Save rating
       
     print(message)
        DispatchQueue.main.async {
            AppDelegate.shared.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            
             let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                 switch action.style{
                     case .default:
                     print("default")
                     
                     case .cancel:
                     print("cancel")
                     
                     case .destructive:
                     print("destructive")
                     
                 }
             }))
             
             AppDelegate.shared.window?.rootViewController?.children.first?.present(alert, animated: true, completion: nil)
        })
        
        
    }
}
