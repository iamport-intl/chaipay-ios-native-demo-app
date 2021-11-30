//
//  ProductDetailsViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import ChaiPayPaymentSDK
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
        return UserDefaults.getMobileNumber
    }
    var formattedSummaryText: String? = UserDefaults.getMobileNumber
    var totalAmount: Double = 0
    var isMobileVerificationDone: Bool = false
    var selectedProductsDict: [String: ProductDetailsObject] = [:]
    var selectedProducts: [ProductDetailsObject] = []
    var productDetailsDataSource: ProductDetailsDataSource?
    var delivery: Double = 0
    var paymentDataSource: [PaymentMethodDataSource] = []
    var paymentMethodResponse: PaymentMethodResponse?
    var cardDetails: CardDetails?
    var savedCards: [SavedCard] = []
    var selectedPaymentMethod: PaymentMethodObject?
    var selectedSavedCard: SavedCard?
    private var shouldShowOTPInputView: Bool = false
    private var savedCardViewIsExpanded: Bool = false
    private var myCartIsExpanded: Bool = true
    var selectedEnvironment: EnvironmentObject? {
        return UserDefaults.getSelectedEnvironment
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupThemedNavbar()
        checkout?.getAvailablePaymentGateways(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.paymentMethodResponse = response
                self.setupInitialData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                break
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(showResponseInfo), name: NSNotification.Name("webViewResponse"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onMerchantUpdate), name: .MerchantUpdated, object: nil)
        
        isMobileVerificationDone = UserDefaults.getAuthorisationToken != nil
        setupInitialData()
        registerCells()
        setupTableView()
        summaryOrderDetails()
        summaryAmount.text = formattedSummaryText
        registerKeyboardNotifications()
        self.navigationItem.title = "checkout".localized
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
        preparePaymentMethodDataSource()
        setupDataSource()
    }
    
    func showSwiftMessagesView(isSuccess: Bool = false, selectedProducts: [ProductDetailsObject] = [],  _ webResponse : WebViewResponse?) {
        print("RESPONE 123", webResponse)
        DispatchQueue.main.async {
            print("RESPONE 110", webResponse)
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
        
        let filteredBankTransfer = paymentMethodResponse?.bankTransfer.filter{
            method in
            method.isDefault &&
                method.isEnabled &&
                method.subType.contains("BANK_TRANSFER")
        }
        
        let walletData = PaymentMethodDataSource(type: .wallet, paymentMethods: filteredWalletsData ?? [], isExpanded: false)
        let newCreditCard = PaymentMethodDataSource(type: .newCreditCard, paymentMethods: filterCreditCards ?? [], isExpanded: false)
        let atmDataSource = PaymentMethodDataSource(type: .atm, paymentMethods: filterATMCards ?? [], isExpanded: false)
        let bankTransfer = PaymentMethodDataSource(type: .bankTransfer, paymentMethods: filteredBankTransfer ?? [], isExpanded: false)
        
        if !(filteredWalletsData?.isEmpty ?? true) {
            paymentDataSource.append(walletData)
        }
        
        paymentDataSource.append(newCreditCard)
        
        if !(filterATMCards?.isEmpty ?? true) {
            paymentDataSource.append(atmDataSource)
        }
        
        if !(filteredBankTransfer?.isEmpty ?? true) {
            paymentDataSource.append(bankTransfer)
        }
    }
    
    func setupDataSource() {
        var detailsSectionItems: [DetailsSectionItem] = []
        
        let productDetailsDataModel = ProductDetailsDataModel(datasource: selectedProducts, isExpanded: myCartIsExpanded)
        detailsSectionItems.append(productDetailsDataModel)
        
        let savedCardsDataSource = SavedCardsPaymentDataModel(datasource: savedCards, shouldShowOTPInputView: shouldShowOTPInputView, mobileNumberVerified: isMobileVerificationDone, isExpand: savedCardViewIsExpanded)
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
        return BillingAddress(city: "VND", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
    }
    
    func prepareConfig() -> TransactionRequest {
        let billingDetails = BillingDetails(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: number ?? "", billingAddress: getBillingadress())
        
        let shippingAddress = ShippingAddress(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
        
        let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
        
        var orderDetails: [OrderDetails] = []
        
        for details in self.selectedProducts {
            let product = OrderDetails(id: details.id ?? "", name: details.title ?? "", price: details.price ?? 0, quantity: 1, imageUrl: details.imageName ?? "")
            orderDetails.append(product)
        }
        
        print("totalAmount", totalAmount)
        let merchantDetails = MerchantDetails(name: "Downy", logo: "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg", backUrl: "https://demo.chaipay.io/checkout.html", promoCode: "Downy350", promoDiscount: 35000, shippingCharges: 0.0)
        
        return TransactionRequest(chaipayKey: selectedEnvironment?.key ?? "", key: selectedEnvironment?.key ?? "", merchantDetails: merchantDetails, paymentChannel: selectedPaymentMethod?.paymentChannelKey ?? "", paymentMethod: selectedPaymentMethod?.paymentChannelKey == "VNPAY" ? "VNPAY_ALL" : selectedPaymentMethod?.paymentMethodKey ?? "", merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))", amount: Int(self.totalAmount), currency: "VND", signatureHash: "123", billingAddress: billingDetails, shippingAddress: shippingDetails, orderDetails: orderDetails, successURL: "https://test-checkout.chaipay.io/success.html", failureURL: "https://test-checkout.chaipay.io/failure.html", redirectURL: "chaipay://checkout", countryCode: "VN")
    }
    
    func showCheckoutVC(_ config: TransactionRequest) {
        checkout?.initiateWalletPayments(config) { result in
            switch result {
            case .success(let data):
                print(data)
            // TODO: Do Nothing
            case .failure(let error):
                print("error", error)
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
            var config = prepareConfig()
            config.paymentMethod = selectedPaymentMethod?.paymentMethodKey ?? "MASTERCARD_CARD"
            config.paymentChannel = selectedPaymentMethod?.paymentChannelKey ?? "MASTERCARD"
            self.showHUD()
            print("Config", config)
            print("CardDetails", cardDetails)
            checkout?.initiateNewCardPayment(config, cardDetails: cardDetails, onCompletionHandler: { (result) in
                var isSuccess: Bool = false
                self.hideHUD()
                switch result {
                case .success(let data):
                    isSuccess = true
                    if(!(data.isSuccess ?? true)) {
                        isSuccess = false
                    }
                    print("data", data)
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, data)
                case .failure(let error):
                    isSuccess = false
                    self.showSwiftMessagesView(isSuccess: isSuccess,  selectedProducts: self.selectedProducts, nil)
                }
            })
            
        } else if let savedCard = selectedSavedCard {
            var config = prepareConfig()
            config.paymentMethod = selectedPaymentMethod?.paymentMethodKey ?? "MASTERCARD_CARD"

            config.paymentChannel = selectedPaymentMethod?.paymentChannelKey ?? "MASTERCARD"
            self.showHUD()
            let cardDetails = CardDetails(token: savedCard.token, cardNumber: savedCard.partialCardNumber, expiryMonth: savedCard.expiryMonth, expiryYear: savedCard.expiryYear, cardHolderName: "NGUYUN VANA A", type: savedCard.type, cvv: "100", savedCard: true)
            checkout?.initiateSavedCardPayment(config, cardDetails: cardDetails, onCompletionHandler: { (result) in
                var isSuccess: Bool = false
                self.hideHUD()
                switch result {
                case .success(let data):
                    print(data)
                    isSuccess = true
                    if(!(data.isSuccess ?? true)) {
                        isSuccess = false
                    }
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, data)
                case .failure:
                    isSuccess = false
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, nil)
                }
                
            })
        } else {
            var config = prepareConfig()
            config.paymentMethod = selectedPaymentMethod?.paymentMethodKey ?? ""
            config.paymentChannel = selectedPaymentMethod?.paymentChannelKey ?? ""
            print(config)
            showCheckoutVC(config)
        }
    }
    
    @objc func showResponseInfo(_ notification: Notification) {
        if let webViewResponse = notification.object as? WebViewResponse {
            let isSuccess: Bool = (webViewResponse.status == "Success") || (webViewResponse.isSuccess ?? false)
            showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, webViewResponse)
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
                cell.layout(basedOn: .otp)
                cell.layoutIfNeeded()
                return cell
            } else {
                print("self.savedCards.count", cards.count)
                print("self.savedCards", savedCards)
                if cards.count > 0 {
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
                if let creditCard = dataSource[indexPath.row].paymentMethods.first, creditCard.tokenizationPossible {
                    sh()
                    selectedPaymentMethod = creditCard
                } else {
                    for (index, value) in dataSource.enumerated() {
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
                            selectedData.isSelected = false
                            selectedData.isExpanded = false
                            
                            if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                                paymentDataSource[selectedIndexPath] = selectedData
                            }
                        }
                    }
                }
            case .atm, .bankTransfer:
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
            default:
                sh()
            }
            
            setupDataSource()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
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
        checkout?.fetchSavedCards(mobileNumber, otp: OTP, onCompletionHandler: { (result) in
            switch result {
            case .success(let values):
                DispatchQueue.main.async {
                    self.isMobileVerificationDone = true
                    self.stackView.isHidden = false
                    print("values.content", values.content)
                    self.savedCards = values.content
                    print("YOO", self.savedCards)
                    if let token = values.token {
                        UserDefaults.persist(token: token)
                    }
                    self.shouldShowOTPInputView = false
                    self.setupInitialData()
                    self.tableView.reloadData()
                }
            case .failure(let error):
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .savedCards:
            savedCardViewIsExpanded = isExpanded
            if savedCardViewIsExpanded {
                if isMobileVerificationDone {
                    fetchSavedCards(mobileNumber: number ?? "", token: UserDefaults.getAuthorisationToken ?? "")
                } else {
                    sendOTP(isExpanded)
                }
            } else {
                self.setupDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func sendOTP(_ isExpanded: Bool) {
        checkout?.getOTP(number ?? "", onCompletionHandler: { (result) in
            switch result {
            case .success:
                //                DispatchQueue.main.async {
                //                    let inputTextViewController: InputTextViewController = ViewControllersFactory.viewController()
                //                    self.present(inputTextViewController, animated: true, completion: nil)
                //                }
                
                self.shouldShowOTPInputView = isExpanded
                self.setupDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print(error)
                self.savedCardViewIsExpanded = false
                self.setupDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func fetchSavedCards(mobileNumber: String, token: String) {
        checkout?.fetchSavedCards(mobileNumber, token: token, onCompletionHandler: { result in
            switch result {
            case .success(let response):
                self.savedCards = response.content
                if let token = response.token {
                    UserDefaults.persist(token: token)
                }
                self.setupDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                if error.httpStatusCode == 401 {
                    UserDefaults.removeAuthorisationToken()
                    self.isMobileVerificationDone = false
                    self.sendOTP(true)
                } else {
                    // TODO: In case of 500, or remaining
                    // Show banner here
                }
            }
        })
    }
}
