//
//  CheckoutV4ViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 11/08/22.
//

import Foundation
import ChaiPayPaymentSDK
import UIKit
import SwiftMessages
import CryptoKit
import React

class CheckoutV4ViewController: UIViewController {
    // MARK: - Outlets
    
    var cartSummaryHeight: Int? = 0 {
        didSet{
            resizePaymentMethodsView()
        }
    }
    var paymentMethodsView: RCTRootView?
    var setCartSummaryView: RCTRootView?
    var payButton: RCTRootView?
    var checkoutElement: RCTRootView?
    var paymentMethodsHeight: Int?
    var selectedProductsDict: [String: ProductDetailsObject] = [:]
    var selectedEnvironment: EnvironmentObject? {
        return UserDefaults.getSelectedEnvironment
    }
    
    @IBOutlet var payNowOuterView: UIView!
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        reactNativeBridge = ReactNativeBridge()
        setcartSummary()
        setPaymentMethods()
        setPayNowButton()
        setCheckoutElement()
        
            
        
        registerKeyboardNotifications()
        self.navigationItem.title = "checkout".localized
    }
    
    
    func setcartSummary() {
        
        setCartSummaryView = CheckoutReactModule.sharedInstance.viewForModule("CartListElement", initialProperties: nil)
        
        setCartSummaryView?.delegate = self
        setCartSummaryView?.sizeFlexibility = .height
        setCartSummaryView?.tag = 100
        
        let view = UIView()
        view.frame = CGRect(x: 15, y: 150, width: 0, height: 0.5)
        setCartSummaryView?.frame = CGRect(x: 0, y: 0, width: 390, height: 0)
        view.addSubview(setCartSummaryView!)
        self.view.addSubview(view)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.95) {
            CheckoutManager.shared?.setInitialData(chaipayKey: "ItjQocRdyfaAFflr", env: "prod", environment: "sandbox", secretKey: "08531c197630fb6882235a569aecd8dbe0a62e3ebc17857e70f13fe1e11a87c1", redirectURL: "chaiport://checkout", currency: "VND")
            
            
            CheckoutManager.shared?.sendCartListUIEvent()
        }
    }
    
    func setCheckoutElement() {
        checkoutElement = CheckoutReactModule.sharedInstance.viewForModule("CheckoutElement", initialProperties: nil)
        
        checkoutElement?.delegate = self
        checkoutElement?.sizeFlexibility = .height
        checkoutElement?.tag = 150
        
        let view = UIView()
        view.frame = CGRect(x: 15, y: 150, width: 300, height: 0.5)
        view.addSubview(checkoutElement!)
        self.view.addSubview(view)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.95) {
            CheckoutManager.shared?.setInitialData(chaipayKey: "ItjQocRdyfaAFflr", env: "prod", environment: "sandbox", secretKey: "08531c197630fb6882235a569aecd8dbe0a62e3ebc17857e70f13fe1e11a87c1", redirectURL: "chaiport://checkout", currency: "VND")
            
            
            CheckoutManager.shared?.sendCheckoutUIEvent()
        }
    }
    
    func resizePaymentMethodsView() {
        DispatchQueue.main.async {
            self.paymentMethodsView?.sizeFlexibility = .height
            self.paymentMethodsView?.frame = CGRect(x: 0, y: (self.cartSummaryHeight ?? 0) + 150, width: 400, height: 400)
        }
    }

    func setPaymentMethods() {
        
        self.paymentMethodsView = CheckoutReactModule.sharedInstance.viewForModule("PaymentMethodsElement", initialProperties: nil)
        paymentMethodsView?.delegate = self
        paymentMethodsView?.sizeFlexibility = .widthAndHeight
        paymentMethodsView?.tag = 11
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
            CheckoutManager.shared?.setInitialData(chaipayKey: "ItjQocRdyfaAFflr", env: "prod", environment: "sandbox", secretKey: "08531c197630fb6882235a569aecd8dbe0a62e3ebc17857e70f13fe1e11a87c1", redirectURL: "chaiport://checkout", currency: "VND")
            CheckoutManager.shared?.sendPaymentMethodsUIEvent()
        }
        
        
        
        self.view.addSubview(paymentMethodsView!)
        
        }
    
    
    
    func setPayNowButton() {
        
        self.payButton = CheckoutReactModule.sharedInstance.viewForModule("PayNowElement", initialProperties: nil)
        payButton?.delegate = self
        payButton?.sizeFlexibility = .widthAndHeight
        payButton?.tag = 12
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
            CheckoutManager.shared?.setInitialData(chaipayKey: "ItjQocRdyfaAFflr", env: "prod", environment: "sandbox", secretKey: "08531c197630fb6882235a569aecd8dbe0a62e3ebc17857e70f13fe1e11a87c1", redirectURL: "chaiport://checkout", currency: "VND")
            CheckoutManager.shared?.sendPayNowUIEvent()
        }
        
        payButton?.frame = CGRect(x: 0, y: 0, width: 1, height: 0)
        
        self.payNowOuterView.addSubview(payButton!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarLargeTitleTheme()
        setupBackButton()
    }
    
    @objc
    func onMerchantUpdate() {
        self.navigationController?.popViewController(animated: true)
    }
    
   
}


extension CheckoutV4ViewController: RCTRootViewDelegate {
    
    func rootViewDidChangeIntrinsicSize(_ rootView: RCTRootView!) {
        var newFrame: CGRect = rootView.frame;
        newFrame.size = rootView.intrinsicContentSize;
        if(rootView.tag == 100) {
            print(rootView)
            print(newFrame.size)
            self.cartSummaryHeight = Int(newFrame.size.height)
        } else if (rootView.tag == 11) {
            self.paymentMethodsHeight = Int(rootView.intrinsicContentSize.height)
            
        }
       
         rootView.frame = newFrame;
    }
}
