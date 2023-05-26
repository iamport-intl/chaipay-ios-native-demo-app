//
//  PreAuthViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 08/05/23.
//

import Foundation
import UIKit
import ChaiPayPaymentSDK

enum TransactionType: String {
    case purchase
    case preAuth
    
    var code: String {
        switch self {
        case .purchase:
            return "PURCHASE"
        case .preAuth:
            return "PREAUTH"
        }
    }
    
    var title: String {
        switch self {
        case .purchase:
            return "Purchase"
        case .preAuth:
            return "Pre-auth"
        }
    }
}

class PreAuthViewController: UIViewController {

//    @IBOutlet weak var routeRefText: UITextField!
//    @IBOutlet weak var saveButton: UIButton!
    var transactionId: String?
    var checkout: Checkout? {
        return AppDelegate.shared.checkout
    }
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = "Select Transaction type"
        }
    }
    @IBOutlet weak var captureTransactionButton: UIButton! {
        didSet {
            captureTransactionButton.applyShadow()
            captureTransactionButton.layer.cornerRadius = 5
            captureTransactionButton.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var transactionIdText: UITextField!
    
    @IBOutlet weak var purchasePlaceholderView: UIView!
    @IBOutlet weak var preAuthPlaceholderView: UIView!
    
   
    @IBOutlet weak var preAuthCheckBoxView: UIView! {
        didSet {
            preAuthCheckBoxView.layer.cornerRadius = 15/2
        }
    }
    @IBOutlet weak var purchaseCheckBoxView: UIView! {
        didSet {
            purchaseCheckBoxView.layer.cornerRadius = 15/2
        }
    }
    
    @IBOutlet weak var preAuthOuterView: UIView! {
        didSet {
            preAuthOuterView.layer.cornerRadius = 25/2
            preAuthOuterView.layer.borderWidth = 1
            preAuthOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var purchaseOuterView: UIView! {
        didSet {
            purchaseOuterView.layer.cornerRadius = 25/2
            purchaseOuterView.layer.borderWidth = 1
            purchaseOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    
    lazy var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named: "icon_cross"), style: .plain, target: self, action: #selector(onClickCancelButton))
        return barButton
    }()
    
    var successCallback: ((String) -> Void)?
    var selectedTransactionType: TransactionType {
        return UserDefaults.getTransactionType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThemedNavbar()
        setupNavBarTitleTheme()
        setupInitialData()
        setupTapGestures()
        transactionIdText.addTarget(self, action: #selector(onChangeTransactionIdTextTextFieldDidChange(_:)), for: .editingChanged)
//        routeRefText.addTarget(self, action: #selector(routeRefTextFieldDidChange(_:)), for: .editingChanged)
       captureTransactionButton.addTarget(self, action: #selector(onCaptureTransaction), for: .touchUpInside)
    }
    
    @objc
    func onChangeTransactionIdTextTextFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.transactionId = textField.text
        }
    }
    @objc
    func onCaptureTransaction() {
        let jwtToken = createJWTToken()
        checkout?.captureTransactionAPI(transactionOrderRef: self.transactionId ?? "", clientKey: UserDefaults.getChaipayKey!, jwtToken: jwtToken) { result in
            switch result {
            case .success(let response):
                self.showData(data: "\(response)")
                return
            case .failure(let error):
                self.showData(data: "\(error)")
                break
            }
        }
    }
    
    func showData(data: String) {
        DispatchQueue.main.async {
            self.responseTextView.text = data
        }
    }
    
    @objc func routeRefTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            UserDefaults.persistRouteRef(routeRef: text)
        }
    }
    
    @objc func onSave() {
        
        //UserDefaults.persistRouteRef(routeRef: routeRefText.text ?? "")
        self.dismiss(animated: true)
    }
    
    func setupInitialData() {
        self.navigationItem.title = NSLocalizedString("Change_Language_Title", comment: "")
        //self.subTitleLabel.text = "Change_Language_Msg".localized
        self.navigationItem.rightBarButtonItem = cancelBarButton
        
        switch selectedTransactionType {
        case .purchase:
            setupThemePurchase()
        case .preAuth:
            setupThemePreAuth()
        }
    }
    
    @objc
    func onClickCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTapGestures() {
        let purchaseTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectPurchase))
        purchaseTapGesture.numberOfTouchesRequired = 1
        purchasePlaceholderView.addGestureRecognizer(purchaseTapGesture)
        
        let preAuthTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectPreAuth))
        preAuthTapGesture.numberOfTouchesRequired = 1
        preAuthPlaceholderView.addGestureRecognizer(preAuthTapGesture)
        
    }
    
    func setupThemePurchase() {
        purchaseCheckBoxView.backgroundColor = UIColor(named: "app_theme_color")
        preAuthCheckBoxView.backgroundColor = UIColor.clear
    }
    
    @objc
    func onSelectPurchase() {
        setupThemePurchase()
        self.changePurchase(.purchase)
    }
    
    func setupThemePreAuth() {
        purchaseCheckBoxView.backgroundColor = UIColor.clear
        preAuthCheckBoxView.backgroundColor = UIColor(named: "app_theme_color")
    }
    
    @objc
    func onSelectPreAuth() {
        setupThemePreAuth()
        self.changePurchase(.preAuth)
    }
    
    func changePurchase(_ purchase: TransactionType) {
        //Set default language as app language
        UserDefaults.persistPreAuthType(preAuthType: purchase)
    
    }
}
