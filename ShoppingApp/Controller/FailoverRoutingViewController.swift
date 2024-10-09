//
//  FailoverRoutingViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 30/05/23.
//

import Foundation
import UIKit
import PortoneSDK

class FailoverRoutingViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var routeRefText: UITextField!
  @IBOutlet weak var failoverPlaceholderView: UIView!
    
    @IBOutlet weak var fetchRoutesButton: UIButton!
    {
        didSet {
            fetchRoutesButton.applyShadow()
            fetchRoutesButton.layer.cornerRadius = 5
            fetchRoutesButton.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBOutlet weak var failoverEnabledCheckBoxView: UIView! {
        didSet {
            failoverEnabledCheckBoxView.layer.cornerRadius = 15/2
        }
    }
    
    @IBOutlet weak var failoverEnabledOuterView: UIView! {
        didSet {
            failoverEnabledOuterView.layer.cornerRadius = 25/2
            failoverEnabledOuterView.layer.borderWidth = 1
            failoverEnabledOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    
    @IBOutlet var tokenIdText: UITextField!
    var checkout: Checkout? {
        return AppDelegate.shared.checkout
    }
    
    override func viewDidLoad() {
        
        routeRefText.addTarget(self, action: #selector(onChangeRouteRefTextFieldDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        fetchRoutesButton.addTarget(self, action: #selector(onFetchRoutes), for: .touchUpInside)
        setupTapGestures()
        setupThemePurchase()
        self.responseTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.responseTextView.delegate = self
    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       // view.endEditing(true)
    }
    
    override var editingInteractionConfiguration: UIEditingInteractionConfiguration {
        return .default
    }
    
    func setupTapGestures() {
        let purchaseTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectfailoverEnabled))
        purchaseTapGesture.numberOfTouchesRequired = 1
        failoverPlaceholderView.addGestureRecognizer(purchaseTapGesture)
        
        
    }
    
    func setupThemePurchase() {
        print("UserDefaults.getRoutingEnabled", UserDefaults.getRoutingEnabled)
        failoverEnabledCheckBoxView.backgroundColor = !UserDefaults.getRoutingEnabled! ? UIColor.clear : UIColor(named: "app_theme_color")
    }
    
    @objc
    func onSelectfailoverEnabled() {
        UserDefaults.persistRoutingEnabled(routingEnabled: !UserDefaults.getRoutingEnabled!)
        setupThemePurchase()
    }
    
    @objc func onChangetokenIdTextTextFieldDidChange(_ textField: UITextField){
        if let text = textField.text {
            UserDefaults.persistTokenId(customerId: text)
        }
    }
    
    @objc func onChangeRouteRefTextFieldDidChange(_ textField: UITextField){
        if let text = textField.text {
            UserDefaults.persistRouteRef(routeRef: text)
        }
    }
    
  
    
    
    func showData(data: String) {
        DispatchQueue.main.async {
            
            self.responseTextView.text = data
        }
    }
    @objc func onSave(){
        
        UserDefaults.persistRouteRef(routeRef: routeRefText.text ?? "")
    }
    
    @objc func onFetchRoutes(){
        let token = createJWTToken()
        if let clientKey = UserDefaults.getChaipayKey {
            checkout?.fetchRoutes(clientKey: clientKey, jwtToken: token, subMerchantKey: nil, onCompletionHandler: {(result) in
                switch result {
                case .success(let data):
                    var values = data.content!.data!.filter{ paymentMethod in
                        print("paymentMethod.isDeleted", paymentMethod.isDeleted!)
                        return paymentMethod.isDeleted != true
                    }
                    self.showData(data: "\(values)")
                    return
                case .failure(let error):
                    self.showData(data: "\(error)")
                    break
                }})
        }
    }
}

