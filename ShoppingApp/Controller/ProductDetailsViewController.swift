//
//  ProductDetailsViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import PortoneSDK
import UIKit
import SwiftMessages
import CryptoKit


class ProductDetailsViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackOuterView: UIView! {
        didSet {
            //stackOuterView.applyShadow()
        }
    }
    @IBOutlet var summaryView: SummaryView! {
        didSet {
            summaryView.isHidden = true
            summaryView.layer.cornerRadius = 10
//            summaryView.applyShadow()
            
        }
    }
    @IBOutlet var summaryViewHeightConstraint: NSLayoutConstraint! {
        didSet{
            summaryViewHeightConstraint.constant = 0
        }
    }
    @IBOutlet var payNowButton: UIButton! {
        didSet {
            payNowButton.layer.cornerRadius = 10
            payNowButton.setTitle("pay_now".localized, for: .normal)
        }
    }
    @IBOutlet var safeAndSecureLabel: UILabel! {
        didSet {
            safeAndSecureLabel.text = "safe_and_secure_payments".localized
        }
    }
    @IBOutlet var summaryAmount: UILabel!
    @IBOutlet var totalLabel: UILabel! {
        didSet {
            totalLabel.text = "total".localized
        }
    }
    @IBOutlet var priceDetailsView: UIView!
    var checkout: Checkout?
    
    // MARK: - Properties
    var number: String? {
        return UserDefaults.getMobileNumber?.removeWhitespace()
    }
    var formattedSummaryText: String? = UserDefaults.getMobileNumber
    var totalAmount: Double = 0
    var isMobileVerificationDone: Bool = false
    var sendOTP: Bool = false
    var selectedProductsDict: [String: ProductDetailsObject] = [:]
    var selectedProducts: [ProductDetailsObject] = []
    var productDetailsDataSource: ProductDetailsDataSource?
    var delivery: Double = 0
    var paymentDataSource: [PaymentMethodDataSource] = []
    var paymentMethodResponse: PaymentMethodResponse?
    var cardDetails: CardDetails?
    var savedCards: [SavedCard]? = []
    var selectedPaymentMethod: PaymentMethodObject? {
        didSet {
            print("selectedPaymentMethod", selectedPaymentMethod)
        }
    }
    var selectedSavedCard: SavedCard?
    private var shouldShowOTPInputView: Bool = false
    private var savedCardViewIsExpanded: Bool = false
    private var myCartIsExpanded: Bool = true
//    var selectedEnvironment: EnvironmentObject? {
//        return UserDefaults.getSelectedEnvironment
//    }
    
    var chaipayKey: String {
        return UserDefaults.getChaipayKey!
    }
    
    var secretKey: String {
        return UserDefaults.getSecretKey!
    }
    
    var env:String {
        return UserDefaults.getDevEnv!.envType
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupThemedNavbar()
        
        
        checkout?.getAvailablePaymentGateways(portOneKey: UserDefaults.getChaipayKey!, currency: UserDefaults.getCurrency.code, subMerchantKey: nil ,completionHandler: { [weak self] result in
            print("result", result)
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.paymentMethodResponse = response
                self.setupInitialData()
                self.reloadData()
            case .failure(let error):
                print("error", error)
                self.showSwiftMessagesView(isSuccess: false, selectedProducts: self.selectedProducts, message: "\(error)")
                break
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(showResponseInfo), name: NSNotification.Name("webViewResponse"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onMerchantUpdate), name: .MerchantUpdated, object: nil)
        print("isMobile", isMobileVerificationDone)
        isMobileVerificationDone = UserDefaults.getAuthorisationToken != nil
        print("isMobile", isMobileVerificationDone)
        setupInitialData()
        registerCells()
        setupTableView()

        registerKeyboardNotifications()
        self.navigationItem.title = "checkout".localized
        self.summaryAmount.text = "\(selectedProducts.map { $0.price ?? 0.0 }.reduce(0.0, +))"
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
    
    func setupInitialData() {
        productDetailsDataSource = ProductDetailsDataSource()
        selectedProducts = Array(selectedProductsDict.values)
        DispatchQueue.main.async {
            AppDelegate.shared.selectedProducts = self.selectedProducts
        }
        
        preparePaymentMethodDataSource()
        setupDataSource()
    }
    
    func showSwiftMessagesView(isSuccess: Bool = false, selectedProducts: [ProductDetailsObject] = [],  webResponse : TransactionResponse?) {
        DispatchQueue.main.async {
            let orderStatusViewController: OrderStatusViewController = ViewControllersFactory.viewController()
            orderStatusViewController.delegate = self
            orderStatusViewController.selectedProducts = selectedProducts
            orderStatusViewController.isSuccess = isSuccess
            orderStatusViewController.response = webResponse
            orderStatusViewController.amount = Int(self.totalAmount ?? 0)
            orderStatusViewController.delivery = Int(self.delivery)
            self.present(orderStatusViewController, animated: true, completion: nil)
        }
    }
    
    func showSwiftMessagesView(isSuccess: Bool = false, selectedProducts: [ProductDetailsObject] = [],  message : String?) {
        
        DispatchQueue.main.async {
            
            let orderStatusViewController: OrderStatusViewController = ViewControllersFactory.viewController()
            orderStatusViewController.delegate = self
            orderStatusViewController.selectedProducts = selectedProducts
            orderStatusViewController.isSuccess = isSuccess
            orderStatusViewController.message1 = message ?? ""
            orderStatusViewController.amount = Int(self.totalAmount ?? 0)
            orderStatusViewController.delivery = Int(self.delivery)
            self.present(orderStatusViewController, animated: true, completion: nil)
        }
    }
    
    
    func preparePaymentMethodDataSource() {
        paymentDataSource = []
        let filteredWalletsData = paymentMethodResponse?.walletMethods.filter{ paymentMethod in
            return paymentMethod.paymentChannelKey != "VNPAY" &&  paymentMethod.isEnabled
        }
        
        let filterATMCards = paymentMethodResponse?.cardMethods.filter{
            method in
            method.isDefault &&
                method.isEnabled &&
                method.subType.contains("ATM_CARD")
        }
        
        let filterCreditCards = paymentMethodResponse?.cardMethods.filter{
            method in
            method.isDefault &&
                method.isEnabled &&
                method.subType.contains("INT_CREDIT_CARD")
        }
        
        let filterCreditDebitCards = paymentMethodResponse?.cardMethods.filter{
            method in
            method.isDefault &&
                method.isEnabled &&
                method.subType.contains("INT_CREDIT_DEBIT_CARD")
        }
        
        let filteredBNPL = paymentMethodResponse?.bnpl.filter{
            method in
                method.isEnabled &&
                method.subType.contains("BNPL")
        }
        
        
        let filteredBankTransfer = paymentMethodResponse?.bankTransfer.filter{
            method in
            method.isDefault &&
                method.isEnabled &&
                method.subType.contains("MOBILE_BANK")
        }
        
        let filteredQRCode = paymentMethodResponse?.QrCode.filter{
            method in
                method.isEnabled &&
                method.subType.contains("QR_CODE")
        }
        
        let filteredNetBanking = paymentMethodResponse?.netBanking.filter{
            method in
                method.isEnabled &&
                method.subType.contains("NET_BANKING")
        }
        
        let filteredCOD = paymentMethodResponse?.cod.filter{
            method in
                method.isEnabled &&
                method.subType.contains("COD")
        }
        
        let filteredCrypto = paymentMethodResponse?.crypto.filter{
            method in
            method.isDefault &&
                method.isEnabled &&
                method.subType.contains("CRYPTO")
        }
        
        let filteredDirectBankTransfer = paymentMethodResponse?.directBankTransfer.filter{
            method in
                method.isEnabled &&
                method.subType.contains("DIRECT_BANK_TRANSFER")
        }
        
        let filteredInstallment = paymentMethodResponse?.instalment.filter{
            (method) in
            
                if (method.paymentChannelKey == "GBPRIMEPAY") {
                return (
                    method.isEnabled &&
                    method.subType.contains("INSTALLMENT")
                )
                } else {
                    return (
                        method.isDefault &&
                        method.isEnabled &&
                        method.subType.contains("INSTALLMENT")
                    );
                }
            
        }
                
                

        
        let walletData = PaymentMethodDataSource(type: .wallet, paymentMethods: filteredWalletsData ?? [], isExpanded: false)
        let newCreditCard = PaymentMethodDataSource(type: .newCreditCard, paymentMethods: filterCreditCards ?? [], isExpanded: false)
        let newCreditDebitCards = PaymentMethodDataSource(type: .creditDebitCards, paymentMethods: filterCreditDebitCards ?? [], isExpanded: false)
        let atmDataSource = PaymentMethodDataSource(type: .atm, paymentMethods: filterATMCards ?? [], isExpanded: false)
        let bankTransfer = PaymentMethodDataSource(type: .bankTransfer, paymentMethods: filteredBankTransfer ?? [], isExpanded: false)
        let bnpl = PaymentMethodDataSource(type: .bnpl, paymentMethods: filteredBNPL ?? [], isExpanded: false)
        
        let netBanking = PaymentMethodDataSource(type: .netBanking, paymentMethods: filteredNetBanking ?? [], isExpanded: false)
        let COD = PaymentMethodDataSource(type: .COD, paymentMethods: filteredCOD ?? [], isExpanded: false)
        let crypto = PaymentMethodDataSource(type: .crypto, paymentMethods: filteredCrypto ?? [], isExpanded: false)
        let qrCode = PaymentMethodDataSource(type: .QRCode, paymentMethods: filteredQRCode ?? [], isExpanded: false)
        let directBanktransfer = PaymentMethodDataSource(type: .directBankTransfer, paymentMethods: filteredDirectBankTransfer ?? [], isExpanded: false)
        let instalment = PaymentMethodDataSource(type: .instalment, paymentMethods: filteredInstallment ?? [], isExpanded: false)
        
        
        if !(filteredWalletsData?.isEmpty ?? true) {
            paymentDataSource.append(walletData)
        }
        
        if !(filterCreditCards?.isEmpty ?? true) {
            paymentDataSource.append(newCreditCard)
        }
       
        if !(filterCreditDebitCards?.isEmpty ?? true) {
            paymentDataSource.append(newCreditDebitCards)
        }
        
        if !(filterATMCards?.isEmpty ?? true) {
            
            paymentDataSource.append(atmDataSource)
        }
        
        if !(filteredBankTransfer?.isEmpty ?? true) {
            paymentDataSource.append(bankTransfer)
        }
        
        if !(filteredBNPL?.isEmpty ?? true) {
            paymentDataSource.append(bnpl)
        }
        
        if !(filteredQRCode?.isEmpty ?? true) {
            paymentDataSource.append(qrCode)
        }
        
        if !(filteredNetBanking?.isEmpty ?? true) {
            paymentDataSource.append(netBanking)
        }
        
        if !(filteredCOD?.isEmpty ?? true) {
            paymentDataSource.append(COD)
        }
        
        if !(filteredCrypto?.isEmpty ?? true) {
            paymentDataSource.append(crypto)
        }
        
        if !(filteredDirectBankTransfer?.isEmpty ?? true) {
            paymentDataSource.append(directBanktransfer)
        }
        if !(filteredInstallment?.isEmpty ?? true) {
            paymentDataSource.append(instalment)
        }
    }
    
    func setupDataSource() {
        var detailsSectionItems: [DetailsSectionItem] = []
        
        let productDetailsDataModel = ProductDetailsDataModel(datasource: selectedProducts, isExpanded: myCartIsExpanded)
        detailsSectionItems.append(productDetailsDataModel)
        
        let savedCardsDataSource = SavedCardsPaymentDataModel(datasource: savedCards ?? [], shouldShowOTPInputView: shouldShowOTPInputView, mobileNumberVerified: isMobileVerificationDone, isExpand: savedCardViewIsExpanded)
        detailsSectionItems.append(savedCardsDataSource)
        
        let productPaymentDataModel = ProductPaymentDataModel(dataSource: paymentDataSource)
        detailsSectionItems.append(productPaymentDataModel)
        productDetailsDataSource?.items = detailsSectionItems
    }
    
    func summaryOrderDetails() {
        let sumOfOrders = selectedProducts.map { $0.price ?? 0.0 }.reduce(0.0, +)
        let formattedSumOfOrdersText = "\(Int(sumOfOrders).formatCurrency())"
        let deliveryFormattedText = "\(Int(delivery).formatCurrency())"
        
        let summary = sumOfOrders + delivery
        totalAmount = summary
        let formattedSummaryText = "\(Int(summary).formatCurrency())"
        
        
        let summaryObject = SummaryObject(orderTitle: "Order", orderValue: formattedSumOfOrdersText, deliveryTitle: "Delivery", deliveryValue: deliveryFormattedText, summaryTitle: "Summary", summaryValue: formattedSummaryText)
        self.formattedSummaryText = formattedSummaryText
        summaryView.layout(basedOn: summaryObject)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 40
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
    
    func registerCells() {
        let cellIdentifiers = [ProductTableViewCell.cellIdentifier,  PaymentMethodTableViewCell.cellIdentifier, MobileNumberTableViewCell.cellIdentifier, NoDataTableViewCell.cellIdentifier]
        tableView.registerCells(cellIdentifiers)
        
        tableView.registerSectionHeaderFooters([TitleHeaderFooterView.cellIdentifier, SavedCardHeaderFooterView.cellIdentifier])
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let keyboardHeight = keyboardFrame.height
        
        let bottomSpacing = keyboardHeight - self.view.safeAreaInsets.bottom - 15
        if priceDetailsView.bounds.height < bottomSpacing {
            self.tableViewBottomConstraint.constant = bottomSpacing - priceDetailsView.bounds.height
        } else {
            
        }
        self.view.layoutIfNeeded()
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableViewBottomConstraint.constant = 15
        self.view.layoutIfNeeded()
    }
    
    func getBillingadress() -> BillingAddress {
//        return BillingAddress(city: "THB", countryCode: "TH", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
        let currency = UserDefaults.getCurrency
        return BillingAddress(city: currency.code, countryCode: "TH", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
    }
    
    func createHash(_ config: TransactionRequest) -> String {
        var message = ""
        message =
        "amount=\(config.amount)" +
        "&client_key=\(config.portOneKey.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&currency=\(config.currency!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&failure_url=\(config.failureURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&merchant_order_id=\(config.merchantOrderId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")" +
        "&success_url=\(config.successURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        
        let secretString = secretKey
        let key = SymmetricKey(data: secretString.data(using: .utf8)!)
        
        let signature = HMAC<SHA256>.authenticationCode(for: message.data(using: .utf8)!, using: key)
        let base64 = Data(signature).toBase64String()
        return base64
    }

    func prepareConfig() -> TransactionRequest {
        let countryCode = UserDefaults.getCurrency.code
        let billingDetails = BillingDetails(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: number ?? "+66900002001", billingAddress: getBillingadress())
        
        let shippingAddress = ShippingAddress(city: "abc", countryCode: "TH", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
        
        let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
        
        var orderDetails: [OrderDetails] = []
        
        for details in self.selectedProducts {
            let product = OrderDetails(id: details.id ?? "", name: details.title ?? "", price: details.price ?? 0, quantity: 1, imageUrl: details.imageName ?? "")
            orderDetails.append(product)
            totalAmount = totalAmount + (details.price ?? 0)
        }
        let promoDiscount = 110.0
        let charges = 100.0
        self.totalAmount = totalAmount + charges - promoDiscount
        let merchantDetails = MerchantDetails(name: "Downy", logo: "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg", backUrl: "https://demo.chaiport.io/checkout.html", promoCode: "Downy350", promoDiscount: promoDiscount, shippingCharges: charges)
        print("UserDefaults.getTransactionType.code",UserDefaults.getTransactionType.code)
        var transactionRequest = TransactionRequest(portOneKey: chaipayKey , key: chaipayKey , merchantDetails: merchantDetails, paymentChannel: selectedPaymentMethod?.paymentChannelKey ?? "", paymentMethod: selectedPaymentMethod?.paymentChannelKey == "VNPAY" ? "VNPAY_ALL" : selectedPaymentMethod?.paymentMethodKey ?? "", merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))", amount: self.totalAmount, currency: countryCode, signatureHash: "123", billingAddress: billingDetails, shippingAddress: shippingDetails, orderDetails: orderDetails, successURL: "https://test-checkout.chaiport.io/success.html", failureURL: "https://test-checkout.chaiport.io/failure.html", redirectURL: "portone1://checkout", countryCode: countryCode, routingEnabled: false, routingParams: nil, transactionType: UserDefaults.getTransactionType.code, bankDetails: nil, directBankTransferDetails: nil)
        let signatureHash = createHash(transactionRequest)
        transactionRequest.signatureHash = signatureHash
        return transactionRequest
    }
    
    func showCheckoutVC(_ config: TransactionRequest) {
        checkout?.initiatePayment(config, subMerchantKey: nil) { result in
            switch result {
            case .success(let data):
                print(data)
            // TODO: Do Nothing
            case .failure(let error):
                print("error", error)
                self.showSwiftMessagesView(isSuccess: false, selectedProducts: self.selectedProducts, message: "\(error)")
            }
        }
    }
    
    @IBAction func onClickShowSummary(_ sender: UIButton) {
        summaryView.isHidden = !summaryView.isHidden
        summaryView.layer.cornerRadius = 10
        summaryViewHeightConstraint.constant = summaryView.isHidden ? 0 : 155
    }
    
    @IBAction func onClickPayNowButton(_ sender: UIButton) {
        if let cardDetails = cardDetails {
            var card = cardDetails

            var config = prepareConfig()
            config.paymentMethod = selectedPaymentMethod?.paymentMethodKey ?? ""
            config.paymentChannel = selectedPaymentMethod?.paymentChannelKey ?? ""
            config.routingEnabled = UserDefaults.getRoutingEnabled
            config.routingParams =  RoutingParams(type: "failover", routeRef: UserDefaults.getRouteRef)
//            self.showHUD()
            print("Config", config.transactionType)
            print("CardDetails", cardDetails)
            
            let jwtToken = createJWTToken()
            print("jwtToken", jwtToken)
            
        
            
            checkout?.initiateNewCardPayment(config: config, cardDetails: card, jwtToken: jwtToken, clientKey: UserDefaults.getChaipayKey!,subMerchantKey: nil, customerUUID: nil, onCompletionHandler: { (result) in
                var isSuccess: Bool = false
//                self.hideHUD()
                print("result", result)
                self.totalAmount = 0
                switch result {
                case .success(let data):
                    isSuccess = true
                    if(!(data.isSuccess ?? true)) {
                        isSuccess = false
                    }
                    print("data", data)
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, webResponse: data)
                case .failure(let error):
                    
                    print("Error", error)
                    isSuccess = false
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, message: error.message)
                }
            })
            
        } else if let savedCard = selectedSavedCard {
            var config = prepareConfig()
            let filterATMCards = paymentMethodResponse?.cardMethods.filter{
                method in
                method.isDefault &&
                    method.isEnabled &&
                    method.subType.contains("ATM_CARD")
            }.first
            
            let filterCreditCards = paymentMethodResponse?.cardMethods.filter{
                method in
                method.isDefault &&
                    method.isEnabled &&
                    method.subType.contains("INT_CREDIT_CARD")
            }.first
            
            let filterCreditDebitCards = paymentMethodResponse?.cardMethods.filter{
                method in
                method.isDefault &&
                    method.isEnabled &&
                    method.subType.contains("INT_CREDIT_DEBIT_CARD")
            }.first
            selectedPaymentMethod = filterCreditCards ?? filterATMCards ?? filterCreditDebitCards
            config.paymentMethod = selectedPaymentMethod?.paymentMethodKey ?? ""

            config.paymentChannel = selectedPaymentMethod?.paymentChannelKey ?? ""
            config.routingEnabled = UserDefaults.getRoutingEnabled
            
            config.routingParams =  RoutingParams(type: "failover", routeRef: UserDefaults.getRouteRef)
//            self.showHUD()
           
            let cardDetails = CardDetails(token: savedCard.token, cardNumber: savedCard.partialCardNumber, expiryMonth: savedCard.expiryMonth, expiryYear: savedCard.expiryYear, cardHolderName: " ", type: savedCard.type, cvv: "100", savedCard: true,key: UserDefaults.getChaipayKey!)
            checkout?.initiateSavedCardPayment(config: config, cardDetails: cardDetails, onCompletionHandler: { (result) in
                var isSuccess: Bool = false
//                self.hideHUD()
                self.totalAmount = 0
                switch result {
                case .success(let data):
                    print(data)
                    isSuccess = true
                    if(!(data.isSuccess ?? true)) {
                        isSuccess = false
                    }
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, webResponse: data)
                case .failure(let error):
                    print(error)
                    isSuccess = false
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, message: error.message)
                }
                
            })
        } else {
            self.totalAmount = 0
            var config = prepareConfig()
            print("selectedPaymentMethod", selectedPaymentMethod)
            config.paymentMethod = selectedPaymentMethod?.paymentMethodKey ?? ""
            config.paymentChannel = selectedPaymentMethod?.paymentChannelKey ?? ""
            print(config)
            showCheckoutVC(config)
        }
    }
    
    @objc func showResponseInfo(_ notification: Notification) {
        if let webViewResponse = notification.object as? TransactionResponse {
            let isSuccess: Bool = (webViewResponse.status == "Success") || (webViewResponse.isSuccess ?? false)
            showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, webResponse: webViewResponse)
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onClickExpandOrderDetails(_ sender: UIBarButtonItem) {}
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension ProductDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return productDetailsDataSource?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetailsDataSource?.items[section].rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = productDetailsDataSource?.items[indexPath.section]
        switch item?.type {
        case .details:
            guard let datasource = (item as? ProductDetailsDataModel)?.datasource, let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellIdentifier) as? ProductTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.layout(basedOn: datasource[indexPath.row])
            return cell
            
        case .savedCards:
            guard let showInputView = (item as? SavedCardsPaymentDataModel)?.shouldShowOTPInputView,
                  let cards = (item as? SavedCardsPaymentDataModel)?.datasource else {
                return UITableViewCell(frame: .zero)
            }
            if showInputView {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MobileNumberTableViewCell.cellIdentifier) as? MobileNumberTableViewCell else {
                    return UITableViewCell(frame: .zero)
                }
                cell.delegate = self
                cell.checkOut = checkout
                
                cell.layout(basedOn: self.isMobileVerificationDone ? .otp : .mobile)
                cell.layoutIfNeeded()
                return cell
            } else {
                print("self.savedCards.count", cards.count)
                print("self.savedCards", savedCards)
                if cards.count > 0  {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.cellIdentifier) as? PaymentMethodTableViewCell else {
                        return UITableViewCell(frame: .zero)
                    }
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.layout(basedOn: cards, savedCard: selectedSavedCard)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.cellIdentifier) as? NoDataTableViewCell else {
                        return UITableViewCell(frame: .zero)
                    }
                    return cell
                }
            }
            
        case .payment:
            guard let dataSource = (item as? ProductPaymentDataModel)?.dataSource, let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.cellIdentifier) as? PaymentMethodTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.selectionStyle = .none
            cell.delegate = self
            cell.layout(basedOn: dataSource[indexPath.row], paymentMethodObject: selectedPaymentMethod, savedCard: selectedSavedCard)
            return cell
            
        default:
            return UITableViewCell(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = productDetailsDataSource?.items[indexPath.section]
        switch item?.type {
        case .details:
            break
            
        case .payment:
            guard let dataSource = (item as? ProductPaymentDataModel)?.dataSource else {
                return
            }
            
            func sh() {
                selectedPaymentMethod = nil
                for (index, value) in dataSource.enumerated() {
                    if index == indexPath.row {
                        var selectedData = value
                        selectedData.isSelected = false
                        selectedData.isExpanded = !selectedData.isExpanded
                        
                        if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                            paymentDataSource[selectedIndexPath] = selectedData
                        }
                    } else {
                        var selectedData = value
                        selectedData.isExpanded = false
                        selectedData.isSelected = false
                        
                        if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                            paymentDataSource[selectedIndexPath] = selectedData
                        }
                    }
                }
            }
            
            switch dataSource[indexPath.row].type {
            case .newCreditCard:
                print("DataSource", dataSource)
                if let creditCard = dataSource[indexPath.row].paymentMethods.first, creditCard.tokenizationPossible {
                    print("credit card", creditCard)
                    sh()
                    selectedPaymentMethod = creditCard
                } else {
                    for (index, value) in dataSource.enumerated() {
                        print("Index", index)
                        print("value", value)
                        if index == indexPath.row {
                            var selectedData = value
                            selectedData.isExpanded = false
                            selectedData.isSelected = !selectedData.isSelected
                            
                            if selectedData.isSelected {
                                selectedPaymentMethod = value.paymentMethods.first
                            } else {
                                selectedPaymentMethod = nil
                            }
                            
                            if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                                paymentDataSource[selectedIndexPath] = selectedData
                            }
                        } else {
                            var selectedData = value
                            print("value", value)
                            selectedData.isSelected = false
                            selectedData.isExpanded = false
                            
                            if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                                print("Selected data", selectedData)
                                paymentDataSource[selectedIndexPath] = selectedData
                            }
                        }
                    }
                }
                
            case .creditDebitCards:
                print("DataSource", dataSource)
                if let creditCard = dataSource[indexPath.row].paymentMethods.first, creditCard.tokenizationPossible {
                    print("credit card", creditCard)
                    sh()
                    selectedPaymentMethod = creditCard
                } else {
                    for (index, value) in dataSource.enumerated() {
                        print("Index", index)
                        print("value", value)
                        if index == indexPath.row {
                            var selectedData = value
                            selectedData.isExpanded = false
                            selectedData.isSelected = !selectedData.isSelected
                            
                            if selectedData.isSelected {
                                selectedPaymentMethod = value.paymentMethods.first
                            } else {
                                selectedPaymentMethod = nil
                            }
                            
                            if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                                paymentDataSource[selectedIndexPath] = selectedData
                            }
                        } else {
                            var selectedData = value
                            print("value", value)
                            selectedData.isSelected = false
                            selectedData.isExpanded = false
                            
                            if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                                print("Selected data", selectedData)
                                paymentDataSource[selectedIndexPath] = selectedData
                            }
                        }
                    }
                }
            case .atm, .bankTransfer, .netBanking:
                if let atmCard = dataSource[indexPath.row].paymentMethods.first, atmCard.tokenizationPossible {
                    print("atmCard card", atmCard)
                    sh()
                    selectedPaymentMethod = atmCard
                } else {
                for (index, value) in dataSource.enumerated() {
                    print(dataSource)
                    if index == indexPath.row {
                        var selectedData = value
                        selectedData.isExpanded = false
                        selectedData.isSelected = !selectedData.isSelected
                        
                        if selectedData.isSelected {
                            selectedPaymentMethod = value.paymentMethods.first
                        } else {
                            selectedPaymentMethod = nil
                        }
                        
                        if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                            paymentDataSource[selectedIndexPath] = selectedData
                        }
                    } else {
//                        selectedPaymentMethod = nil
                        var selectedData = value
                        selectedData.isSelected = false
                        selectedData.isExpanded = false
                        print("paymentDataSource", paymentDataSource)
                        print("selectedData", selectedData)
                        if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                            paymentDataSource[selectedIndexPath] = selectedData
                        }
                    }
                }
                }
            default:
                sh()
            }
            
            setupDataSource()
            self.reloadData()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return productDetailsDataSource?.items[indexPath.section].rowHeight ?? 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = productDetailsDataSource?.items[section]
        switch item?.type {
        case .savedCards, .details:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SavedCardHeaderFooterView.cellIdentifier) as? SavedCardHeaderFooterView else {
                return emptyView()
            }
            
            headerView.delegate = self
            headerView.layout(basedOn: item?.sectionTitle ?? "", viewType: item?.type == .savedCards ? .savedCards : .myCart, isExpanded: item?.type == .savedCards ? savedCardViewIsExpanded : myCartIsExpanded)
            return headerView
            
        default:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderFooterView.cellIdentifier) as? TitleHeaderFooterView else {
                return emptyView()
            }
            headerView.layout(basedOn: item?.sectionTitle ?? "", applyShadow: false)
            return headerView
        }
    }
    
    private func emptyView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return emptyView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return productDetailsDataSource?.items[section].headerHeight ?? 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return productDetailsDataSource?.items[section].footerHeight ?? 0.01
    }
}

extension ProductDetailsViewController : PaymentMethodDelegate {
    func newCardDetails(cardDetails: CardDetails) {
        self.cardDetails = cardDetails
    }
    
    func selectedPaymentMethod(method: PaymentMethodObject) {
        self.cardDetails = nil
        self.selectedSavedCard = nil
        self.selectedPaymentMethod = method
        self.reloadData()
    }
    
    func selectedSavedCard(method: SavedCard) {
        self.cardDetails = nil
        self.selectedPaymentMethod = nil
        self.selectedSavedCard = method
        self.reloadData()
    }
}

extension ProductDetailsViewController : MobileNumberViewDelegate {
    func fetchSavedCards(_ mobileNumber: String, _ OTP: String) {
        checkout?.fetchSavedCards(portOneKey: UserDefaults.getChaipayKey!, mobileNumber, otp: OTP, token: nil,  onCompletionHandler: { (result) in
            switch result {
            case .success(let values):
                DispatchQueue.main.async {
                    self.isMobileVerificationDone = true
                    self.stackView.isHidden = false
                    print("values.content", values)
                    self.savedCards = values.content
                    print("YOO", self.savedCards)
                    if let token = values.token {
                        UserDefaults.persist(token: token)
                    }
                    self.shouldShowOTPInputView = false
                    self.setupInitialData()
                    self.reloadData()
                }
            case .failure(let error):
                print("error", error)
                self.isMobileVerificationDone = false
                UserDefaults.removeAuthorisationToken()
                self.showSwiftMessagesView(isSuccess: false, selectedProducts: self.selectedProducts, message: error.message)
                break
            }
        })
    }
}
extension ProductDetailsViewController: OrderStatusDelegate {
    func goBack(fromSuccess: Bool) {
        self.navigationController?.popViewController(animated: true)
        
        self.navigationController?.children.first?.dismiss(animated: true, completion: nil) 
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailsViewController: SavedCardHeaderFooterViewDelegate {
    func onClickSavedCard(_ isExpanded: Bool, _ viewType: SectionHeaderViewType) {
        switch viewType {
        case .myCart:
            myCartIsExpanded = isExpanded
            self.setupDataSource()
            self.reloadData()
        case .savedCards:
            savedCardViewIsExpanded = isExpanded
            if savedCardViewIsExpanded {
                if isMobileVerificationDone , let num = number{
                    print("nium", num)
                    fetchSavedCards(mobileNumber: number ?? "", token: UserDefaults.getAuthorisationToken ?? "")
                } else {
                    if let num = number, isMobileVerificationDone {
                    sendOTP(isExpanded)
                    }
                    
                    //                    UserDefaults.removeAuthorisationToken()
                    //                    print(UserDefaults.getAuthorisationToken)
                                        shouldShowOTPInputView = true
                                        self.setupDataSource()
                    self.reloadData()
                    
                }
            } else {
                self.setupDataSource()
                self.reloadData()
            }
        }
    }
    
    func sendOTP(_ isExpanded: Bool) {
        self.sendOTP = isExpanded
        checkout?.getOTP(number ?? "", onCompletionHandler: { (result) in
            switch result {
            case .success:
                
                
                self.shouldShowOTPInputView = isExpanded
                self.setupDataSource()
                self.reloadData()
            case.failure(let error):
                print(error)
                self.savedCardViewIsExpanded = false
                self.setupDataSource()
                self.reloadData()
            }
        })
    }
    
    func fetchSavedCards(mobileNumber: String, token: String) {
        print("mobile number", mobileNumber)
        print("token", token)
        let formattedNumber = mobileNumber.removeWhitespace()
        print("num", formattedNumber)
        checkout?.fetchSavedCards(portOneKey: UserDefaults.getChaipayKey!,formattedNumber, otp: "", token: token, onCompletionHandler: {
         result in
            switch result {
            case .success(let response):
                self.savedCards = response.content
                if let token = response.token {
                    UserDefaults.persist(token: token)
                }
                self.setupDataSource()
                self.reloadData()
            case .failure(let error):
                print("Error", error)
                if error.httpStatusCode == 401 {
                    UserDefaults.removeAuthorisationToken()
                    self.isMobileVerificationDone = false
                    self.sendOTP(true)
                } else {
                    // TODO: In case of 500, or remaining
                    // Show banner here
                    UserDefaults.removeAuthorisationToken()
                    self.isMobileVerificationDone = false
                    print("Error")
                }
            }
        })
    }
}
