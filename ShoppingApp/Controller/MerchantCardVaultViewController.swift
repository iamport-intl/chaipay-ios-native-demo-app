//
//  MerchantCardVaultViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 09/05/23.
//

import Foundation
import UIKit
import PortoneSDK

class MerchantCardVaultViewController: UIViewController , UITextViewDelegate{
    @IBOutlet weak var customerIdText: UITextField!
    //@IBOutlet weak var routeRefText: UITextField!
  //@IBOutlet weak var failoverPlaceholderView: UIView!
    @IBOutlet weak var addCardButton: UIButton! {
        didSet {
            addCardButton.applyShadow()
            addCardButton.layer.cornerRadius = 5
            addCardButton.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var addCardButton2: UIButton!
    {
        didSet {
            addCardButton2.applyShadow()
            addCardButton2.layer.cornerRadius = 5
            addCardButton2.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var deleteCardButton: UIButton!
    {
        didSet {
            deleteCardButton.applyShadow()
            deleteCardButton.layer.cornerRadius = 5
            deleteCardButton.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var deleteCardButton2: UIButton!
    {
        didSet {
            deleteCardButton2.applyShadow()
            deleteCardButton2.layer.cornerRadius = 5
            deleteCardButton2.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var fetchAllCardsButton: UIButton!
    {
        didSet {
            fetchAllCardsButton.applyShadow()
            fetchAllCardsButton.layer.cornerRadius = 5
            fetchAllCardsButton.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var addCustomerButton: UIButton!
    {
        didSet {
            addCustomerButton.applyShadow()
            addCustomerButton.layer.cornerRadius = 5
            addCustomerButton.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var fetchCustomerButton: UIButton!
    {
        didSet {
            fetchCustomerButton.applyShadow()
            fetchCustomerButton.layer.cornerRadius = 5
            fetchCustomerButton.backgroundColor = UIColor.lightGray
        }
    }
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var newCardView: NewCardView! {
        didSet {
            
            newCardView.applyShadow()
            newCardView.layer.cornerRadius = 5
            newCardView.delegate = self
        }
    }
    
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
    var cardDetails: CardDetails?
    var checkout: Checkout? {
        return AppDelegate.shared.checkout
    }
    
    override func viewDidLoad() {
        customerIdText.addTarget(self, action: #selector(onChangeCustomerIdTextTextFieldDidChange(_:)), for: .editingChanged)
        tokenIdText.addTarget(self, action: #selector(onChangetokenIdTextTextFieldDidChange(_:)), for: .editingChanged)
//        routeRefText.addTarget(self, action: #selector(onChangeRouteRefTextFieldDidChange(_:)), for: .editingChanged)
        addCardButton.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
        addCardButton2.addTarget(self, action: #selector(onAddCard), for: .touchUpInside)
        deleteCardButton.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        deleteCardButton2.addTarget(self, action: #selector(onDeleteCard), for: .touchUpInside)
        fetchAllCardsButton.addTarget(self, action: #selector(onFetchListOfCards), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        addCustomerButton.addTarget(self, action: #selector(onClickAddCustomer), for: .touchUpInside)
        fetchCustomerButton.addTarget(self, action: #selector(onClickFetchCustomer), for: .touchUpInside)
        newCardView.isHidden = true
        stackView.isHidden = true
        setupTapGestures()
        setupThemePurchase()
        self.responseTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.customerIdText.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.newCardView.cardHolderNameTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.newCardView.cardNumberTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.newCardView.expiryDateTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        self.newCardView.cvvTextField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showResponseInfo), name: NSNotification.Name("AddCustomerResponse"), object: nil)
        
    }
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
    }
    
    @objc func showResponseInfo(_ notification: Notification) {
       
        showData(data: "\(notification.object)")
    }
    func setupTapGestures() {
        let purchaseTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectfailoverEnabled))
        purchaseTapGesture.numberOfTouchesRequired = 1
        //failoverPlaceholderView.addGestureRecognizer(purchaseTapGesture)
        
        
    }
    
    func setupThemePurchase() {
        print("UserDefaults.getRoutingEnabled", UserDefaults.getRoutingEnabled)
//        failoverEnabledCheckBoxView.backgroundColor = !UserDefaults.getRoutingEnabled! ? UIColor.clear : UIColor(named: "app_theme_color")
    }
    
    @objc
    func onClickAddCustomer() {
        let AddCustomerVc: AddCustomerViewController = ViewControllersFactory.viewController()
        print("self.navigation", self.navigationController)
        self.present(AddCustomerVc, animated: true, completion: nil)
    }
    
    @objc
    func onClickFetchCustomer() {
        let AddCustomerVc: AddCustomerViewController = ViewControllersFactory.viewController()
        AddCustomerVc.fromGetCustomer = true
        self.present(AddCustomerVc, animated: true, completion: nil)
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
    @objc func onChangeCustomerIdTextTextFieldDidChange(_ textField: UITextField){
        if let text = textField.text {
            UserDefaults.persistCustomerId(customerId: text)
        }
    }
    
//    @objc func onChangeRouteRefTextFieldDidChange(_ textField: UITextField){
//        if let text = textField.text {
//            UserDefaults.persistRouteRef(routeRef: text)
//        }
//    }
    
    @objc func onAdd(){
        newCardView.isHidden = false
        newCardView.cardHolderNameTextField.resignFirstResponder()
        newCardView.cardNumberTextField.resignFirstResponder()
        newCardView.expiryDateTextField.resignFirstResponder()
        newCardView.cvvTextField.resignFirstResponder()
        stackView.isHidden = true
    }
    
    @objc func onAddCard() {
        
        let token = createJWTToken()
        if let customerId = UserDefaults.getCustomerId , self.cardDetails != nil {
            checkout?.addCardForCustomerId(customerId: customerId, clientKey: UserDefaults.getChaipayKey ?? " ", cardData: self.cardDetails, jwtToken: token, subMerchantKey: nil, onCompletionHandler: { (result) in
                switch result {
                case .success(let data):
                    self.showData(data: "\(data)")
                    return
                case.failure(let error):
                    self.showData(data: "\(error)")
                    break
                }
            })
        }

    }
    
    @objc func onDelete(){
        newCardView.isHidden = true
        stackView.isHidden = false
        
    }
    
    @objc func onDeleteCard(){
        
        if let customerId = UserDefaults.getCustomerId, let clientKey = UserDefaults.getChaipayKey, let token = UserDefaults.getTokenId {
            print("token", token)
            checkout?.deleteCardForCustomerId(customerId: customerId, clientKey: clientKey, jwtToken: createJWTToken(), cardData: DeleteCardDataObject(token: token), subMerchantKey: nil, onCompletionHandler: {(result) in
                switch result {
                case .success(let data):
                    self.showData(data: "\(data)")
                    return
                case .failure(let error):
                    self.showData(data: "\(error)")
                    break
                }})
        }
        
    }
    
    @objc func onFetchListOfCards(){
        let token = createJWTToken()
        print("UserDefaults.getCustomerId", UserDefaults.getCustomerId)
        if let customerId = UserDefaults.getCustomerId, let clientKey = UserDefaults.getChaipayKey {
            print(clientKey)
            print(token)
            print(customerId)
            checkout?.fetchCustomerCards(customerId: customerId, clientKey: clientKey, jwtToken: token, subMerchantKey: nil, onCompletionHandler: {(result) in
                switch result {
                case .success(let data):
                    self.showData(data: "\(data)")
                    return
                case .failure(let error):
                    self.showData(data: "\(error)")
                    break
                }})
        }
    }
    
    func showData(data: String) {
        DispatchQueue.main.async {
            
            self.responseTextView.text = data
        }
    }
    @objc func onSave(){
        UserDefaults.persistCustomerId(customerId: customerIdText.text ?? "")
        //UserDefaults.persistRouteRef(routeRef: routeRefText.text ?? "")
    }
    
//    @objc func onFetchRoutes(){
//        let token = createJWTToken()
//        if let clientKey = UserDefaults.getChaipayKey {
//            checkout?.fetchRoutes(clientKey: clientKey, jwtToken: token, onCompletionHandler: {(result) in
//                switch result {
//                case .success(let data):
//                    var values = data.content!.data!.filter{ paymentMethod in
//                        print("paymentMethod.isDeleted", paymentMethod.isDeleted!)
//                        return paymentMethod.isDeleted != true
//                    }
//                    self.showData(data: "\(values)")
//                    return
//                case .failure(let error):
//                    self.showData(data: "\(error)")
//                    break
//                }})
//        }
//    }
    
    func newCardDetails(cardDetails: CardDetails) {
        self.cardDetails = cardDetails
        
    }
}

extension MerchantCardVaultViewController: NewCardDataDelegate {
    func cardDetails(_ details: CardDetails) {
        self.newCardDetails(cardDetails: details)
    }
}

extension UITextView {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

extension UITextField{

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
