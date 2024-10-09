//
//  AddCustomerViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 01/06/23.
//

import Foundation
import UIKit
import PortoneSDK

class AddCustomerViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var customerRef: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var customerRefLabel: UILabel!
    @IBOutlet weak var AddFetchButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    var fromGetCustomer: Bool? = false
    var progressHUD:ProgressHUD?
    var checkout: Checkout? {
        return AppDelegate.shared.checkout
    }
    @IBOutlet weak var responseTextView: UITextView!
    
    @IBOutlet weak var AddCustomerButton: UIButton! {
        didSet {
            AddCustomerButton.applyShadow()
            AddCustomerButton.layer.cornerRadius = 5
            AddCustomerButton.backgroundColor = UIColor.lightGray

        }
    }
    @IBOutlet weak var close: UIButton!
    @IBAction func onClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        
        AddCustomerButton.addTarget(self, action: #selector(onAddCustomer), for: .touchUpInside)
        progressHUD = ProgressHUD(text: "In progress")
        if let hud = progressHUD {
            self.view.addSubview(hud)
        }
        if(fromGetCustomer == true) {
            self.name.isHidden = true
            self.phoneNumber.isHidden = true
            self.email.isHidden = true
            topLabel.text = "Get Customer Data"
            nameLabel.isHidden = true
            emailLabel.isHidden = true
            numLabel.isHidden = true
            AddFetchButton.setTitle("Get Customer Data", for: .normal)
        } else {
            self.name.isHidden = false
            self.phoneNumber.isHidden = false
            self.email.isHidden = false
        }
        progressHUD?.hide()
        self.name.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.phoneNumber.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.email.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.customerRef.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.responseTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
    }
    
    
    @objc func onAddCustomer(){
        if (fromGetCustomer == true) {
            onFetchCustomer()
        } else {
            let token = createJWTToken()
            if let clientKey = UserDefaults.getChaipayKey {
                
                checkout?.addCustomer(clientKey: clientKey, customerData: AddCustomerObject(name: name.text, phoneNumber: phoneNumber.text, emailAddress: email.text, customerRef: customerRef.text), jwtToken: token, subMerchantKey: nil, onCompletionHandler: { result in
                    switch result {
                    case .success(let response):
                        self.progressHUD?.show()
                        print("response", response)
                        self.showData(data: "UUID: \(response.content.customerUUID) \n \(response)")
                        print("response", response)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                            self.progressHUD?.hide()
                            
                        }
                        break
                    case .failure(let error):
                        self.progressHUD?.show()
                        self.showData(data: "\(error)")
                        print("Failure", error)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                            self.progressHUD?.hide()
                            
                        }
                        break
                    }
                })
            }
        }
    }
    
    @objc func onFetchCustomer(){
        let token = createJWTToken()
        if let clientKey = UserDefaults.getChaipayKey {
            checkout?.getCustomerData(customerID: self.customerRef.text?.removeWhitespace(),  clientKey: clientKey, jwtToken: token, onCompletionHandler: { result in
                switch result {
                case .success(let response):
                    self.progressHUD?.show()
                    print("response", response)
                    self.showData(data: "UUID: \(response.content.customerUUID) \n \(response)")
                    print("response", response)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.progressHUD?.hide()
                       
                    }
                    break
                case .failure(let error):
                    self.progressHUD?.show()
                    self.showData(data: "\(error)")
                    print("Failure", error)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.progressHUD?.hide()
                      
                    }
                    break
                }
            })
        }
        
    }
    
    func showData(data: String) {
        DispatchQueue.main.async {
            
            self.responseTextView.text = data
        }
    }
}

