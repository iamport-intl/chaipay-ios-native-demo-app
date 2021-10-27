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
            summaryView.applyShadow()
            
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
        }
    }
    
    @IBOutlet var summaryAmount: UILabel!
    var checkout: Checkout?
    
    // MARK: - Properties
    var filterCardList: PaymentMethodObject?
    var formattedSummaryText: String = ""
    var totalAmount: Double = 0
    var isMobileVerificationDone: Bool = false
    var selectedProductsDict: [String: ProductDetailsObject] = [:]
    var selectedProducts: [ProductDetailsObject] = []
    var productDetailsDataSource: ProductDetailsDataSource?
    var delivery: Double = 149
    var paymentDataSource: [PaymentMethodDataSource] = []
    var savedCardDataSource: [PaymentMethodDataSource] = []
    var paymentMethodResponse: PaymentMethodResponse?
    var cardDetails: CardDetails?
    var savedCards: [SavedCard] = []
    var selectedPaymentMethod: PaymentMethodObject?
    var selectedSavedCard: SavedCard?
    private var shouldShowOTPInputView: Bool = false
    private var savedCardViewIsExpanded: Bool = false
    private var myCartIsExpanded: Bool = true
    
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
        setupInitialData()
        registerCells()
        setupTableView()
        summaryOrderDetails()
        summaryAmount.text = formattedSummaryText
        registerKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBarLargeTitleTheme(title: "Checkout", color: .black)
        setupNavBarTitleTheme(color: .black)
    }
    
    func setupInitialData() {
        productDetailsDataSource = ProductDetailsDataSource()
        selectedProducts = Array(selectedProductsDict.values)
        preparePaymentMethodDataSource()
        setupDataSource()
    }
    
    func showSwiftMessagesView(isSuccess: Bool = false, selectedProducts: [ProductDetailsObject] = [],  _ response : WebViewResponse?) {
        DispatchQueue.main.async {
            //            guard let view = Bundle.main.loadNibNamed("ResponseView", owner: nil, options: nil)?.first as? ResponseView  else { return }
            //            view.delegate = self
            //            view.frame = CGRect(x: 50, y: 50, width: self.view.frame.height, height: self.view.frame.height)
            //            view.layer.cornerRadius = 10
            //            view.setLayout(isSuccess: isSuccess, amount: self.formattedSummaryText,  response, selectedProducts: selectedProducts)
            //            var config = SwiftMessages.defaultConfig
            //            config.presentationStyle = .center
            //            config.presentationContext = .window(windowLevel: .normal)
            //            config.duration = .forever
            //            config.dimMode = .gray(interactive: true)
            //            SwiftMessages.show(config: config, view: view)
            
            let orderStatusViewController: OrderStatusViewController = ViewControllersFactory.viewController()
            orderStatusViewController.selectedProducts = selectedProducts
            orderStatusViewController.isSuccess = isSuccess
            orderStatusViewController.response = response
            orderStatusViewController.amount = self.formattedSummaryText
            self.present(orderStatusViewController, animated: true, completion: nil)
        }
    }
    
    func preparePaymentMethodDataSource() {
        
        let filteredWalletsData = paymentMethodResponse?.walletMethods.filter{ paymentMethod in
            return paymentMethod.paymentChannelKey != "VNPAY" &&  paymentMethod.isEnabled
        }
        let otherPaymentsData = paymentMethodResponse?.walletMethods.filter( {$0.paymentChannelKey == "VNPAY"})
        
        filterCardList = paymentMethodResponse?.cardMethods.filter{
            method in
            method.isDefault &&
                method.isEnabled &&
                method.subType.contains("INT_CREDIT_CARD")
        }.first
        
        let walletData = PaymentMethodDataSource(type: .wallet, paymentMethods: filteredWalletsData ?? [], isExpanded: false)
        //        let savedCards = PaymentMethodDataSource(type: .savedCards, paymentMethods: [], cardPayments: self.savedCards, isExpanded: false)
        let newCreditCard = PaymentMethodDataSource(type: .newCreditCard, paymentMethods: [], isExpanded: false)
        let otherPayments = PaymentMethodDataSource(type: .otherPayments, paymentMethods: otherPaymentsData ?? [], isExpanded: false)
        paymentDataSource = [ newCreditCard, walletData, otherPayments]
    }
    
    func setupDataSource() {
        var detailsSectionItems: [DetailsSectionItem] = []
        
        let productDetailsDataModel = ProductDetailsDataModel(datasource: selectedProducts, isExpanded: myCartIsExpanded)
        detailsSectionItems.append(productDetailsDataModel)
        
        let savedCardsDataSource = SavedCardsPaymentDataModel(datasource: savedCardDataSource, shouldShowOTPInputView: shouldShowOTPInputView, mobileNumberVerified: isMobileVerificationDone, isExpand: savedCardViewIsExpanded)
        detailsSectionItems.append(savedCardsDataSource)
        
        let productPaymentDataModel = ProductPaymentDataModel(dataSource: paymentDataSource)
        detailsSectionItems.append(productPaymentDataModel)
        productDetailsDataSource?.items = detailsSectionItems
    }
    
    func summaryOrderDetails() {
        let sumOfOrders = selectedProducts.map { $0.price ?? 0.0 }.reduce(0.0, +)
        let formattedSumOfOrdersText = (selectedProducts.first?.currency ?? "") + "\(sumOfOrders)"
        let deliveryFormattedText = "\(selectedProducts.first?.currency ?? "")" + "\(delivery)"
        
        let summary = sumOfOrders + delivery
        totalAmount = summary
        let formattedSummaryText = "\(selectedProducts.first?.currency ?? "")" + "\(summary)"
        
        
        let summaryObject = SummaryObject(orderTitle: "Order", orderValue: formattedSumOfOrdersText, deliveryTitle: "Delivery", deliveryValue: deliveryFormattedText, summaryTitle: "Summary", summaryValue: formattedSummaryText)
        self.formattedSummaryText = formattedSummaryText
        summaryView.layout(basedOn: summaryObject)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 40
        tableView.estimatedRowHeight = 80
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
        
        let bottomSpacing = keyboardHeight + 12 - self.view.safeAreaInsets.bottom
        let height = self.view.bounds.height - tableView.bounds.height
        
        self.tableViewBottomConstraint.constant = abs(bottomSpacing - height)
        self.view.layoutIfNeeded()
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableViewBottomConstraint.constant = 15
        self.view.layoutIfNeeded()
    }
    
    func getBillingadress() -> BillingAddress {
        return BillingAddress(city: "VND", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
    }
    
    func prepareConfig() -> TransactionRequest {
        let billingDetails = BillingDetails(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: "+918309814058", billingAddress: getBillingadress())
        
        let shippingAddress = ShippingAddress(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
        
        let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
        
        var orderDetails: [OrderDetails] = []
        
        for details in self.selectedProducts {
            let product = OrderDetails(id: details.id ?? "", name: details.title ?? "", price: details.price ?? 0, quantity: 1, imageUrl: details.imageName ?? "")
            orderDetails.append(product)
        }
        
        print("totalAmount", totalAmount)
        let merchantDetails = MerchantDetails(name: "Downy", logo: "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg", backUrl: "https://demo.chaipay.io/checkout.html", promoCode: "Downy350", promoDiscount: 35000, shippingCharges: 0.0)
        
        return TransactionRequest(chaipayKey: "aiHKafKIbsdUJDOb", key: "aiHKafKIbsdUJDOb", merchantDetails: merchantDetails, paymentChannel: selectedPaymentMethod?.paymentChannelKey ?? "", paymentMethod: selectedPaymentMethod?.paymentChannelKey == "VNPAY" ? "VNPAY_ALL" : selectedPaymentMethod?.paymentMethodKey ?? "", merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))", amount: Int(self.totalAmount), currency: "VND", signatureHash: "123", billingAddress: billingDetails, shippingAddress: shippingDetails, orderDetails: orderDetails, successURL: "chaipay://", failureURL: "chaipay://", redirectURL: "chaipay://", countryCode: "VND")
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
        summaryViewHeightConstraint.constant = summaryView.isHidden ? 0 : 92
    }
    
    @IBAction func onClickPayNowButton(_ sender: UIButton) {
        if let cardDetails = cardDetails {
            var config = prepareConfig()
            config.paymentMethod = filterCardList?.paymentMethodKey ?? "MASTERCARD_CARD"
            config.paymentChannel = filterCardList?.paymentChannelKey ?? "MASTERCARD"
            self.showHUD()
            print("Config", config)
            print("CardDetails", cardDetails)
            checkout?.initiateNewCardPayment(config, cardDetails: cardDetails, onCompletionHandler: { (result) in
                var isSuccess: Bool = false
                self.hideHUD()
                switch result {
                case .success(let data):
                    isSuccess = true
                    if(data.isSuccess == "false") {
                        isSuccess = false
                    }
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, data)
                case .failure(let error):
                    isSuccess = false
                    self.showSwiftMessagesView(isSuccess: isSuccess,  selectedProducts: self.selectedProducts, nil)
                }
                
                
            })
            
        } else if let savedCard = selectedSavedCard {
            var config = prepareConfig()
            config.paymentMethod = "MASTERCARD_CARD"
            config.paymentChannel = "MASTERCARD"
            self.showHUD()
            let cardDetails = CardDetails(token: savedCard.token, cardNumber: savedCard.partialCardNumber, expiryMonth: savedCard.expiryMonth, expiryYear: savedCard.expiryYear, cardHolderName: "NGUYUN VANA A", type: savedCard.type, cvv: "100")
            checkout?.initiateSavedCardPayment(config, cardDetails: cardDetails, onCompletionHandler: { (result) in
                var isSuccess: Bool = false
                self.hideHUD()
                switch result {
                case .success(let data):
                    print(data)
                    isSuccess = true
                    if(data.isSuccess == "false") {
                        isSuccess = false
                    }
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, data)
                case .failure(let _):
                    isSuccess = false
                    self.showSwiftMessagesView(isSuccess: isSuccess, selectedProducts: self.selectedProducts, nil)
                }
                
            })
        } else {
            let config = prepareConfig()
            print(config)
            showCheckoutVC(config)
        }
    }
    
    @objc func showResponseInfo(_ notification: Notification) {
        if let webViewResponse = notification.object as? WebViewResponse {
            let isSuccess: Bool = (webViewResponse.status == "Success") || (webViewResponse.isSuccess == "true")
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
                  let savedCards = (item as? SavedCardsPaymentDataModel)?.datasource else {
                return UITableViewCell(frame: .zero)
            }
            if showInputView {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MobileNumberTableViewCell.cellIdentifier) as? MobileNumberTableViewCell else {
                    return UITableViewCell(frame: .zero)
                }
                cell.delegate = self
                cell.checkOut = checkout
                cell.layout(basedOn: .otp)
                return cell
            } else {
                if savedCards.count > 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.cellIdentifier) as? PaymentMethodTableViewCell else {
                        return UITableViewCell(frame: .zero)
                    }
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.layout(basedOn: savedCards[indexPath.row], paymentMethodObject: selectedPaymentMethod, savedCard: selectedSavedCard)
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
            guard let datasource = (item as? ProductDetailsDataModel)?.datasource else {
                return
            }
            
        case .payment:
            guard let dataSource = (item as? ProductPaymentDataModel)?.dataSource else {
                return
            }
            
            var selectedData = dataSource[indexPath.row]
            selectedData.isExpanded = !selectedData.isExpanded
            
            if let selectedIndexPath = paymentDataSource.firstIndex(where: { $0.type == selectedData.type }) {
                paymentDataSource[selectedIndexPath] = selectedData
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
                    self.savedCards = values.content
                    UserDefaults.persist(token: values.token)
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
        if(fromSuccess) {
            SwiftMessages.hide()
            self.navigationController?.popViewController(animated: true)
        } else {
            SwiftMessages.hide()
        }
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
                    fetchSavedCards(mobileNumber: UserDefaults.getMobileNumber ?? "", token: UserDefaults.getAuthorisationToken ?? "")
                } else {
                    checkout?.getOTP(UserDefaults.getMobileNumber ?? "", onCompletionHandler: { (result) in
                        switch result {
                        case .success(let data):
                            self.shouldShowOTPInputView = isExpanded
                            self.setupDataSource()
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        case.failure(let error):
                            print(error)
                            break
                        }
                    })
                }
            } else {
                self.setupDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchSavedCards(mobileNumber: String, token: String) {
        checkout?.fetchSavedCards(mobileNumber, token: token, onCompletionHandler: { result in
            switch result {
            case .success(let response):
                self.savedCards = response.content
                UserDefaults.persist(token: response.token)
                self.setupDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                UserDefaults.removeAuthorisationToken()
                self.isMobileVerificationDone = false
                self.setupDataSource()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}
