//
//  ProductListViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit
import SwiftMessages
import ChaiPayPaymentSDK
import CryptoKit

enum SortType {
    case ascending
    case descending
}

class ProductListViewController: UIViewController {
    // MARK: - Outlets

    var appThemeColor = ""
    
    var formattedSummaryText: String = ""
    var checkout = AppDelegate.shared.checkout
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var shadowView: UIView! {
        didSet {
            shadowView.applyShadow()
        }
    }

    @IBOutlet var buyNowButton: UIButton! {
        didSet {
            buyNowButton.layer.cornerRadius = 10
            buyNowButton.isEnabled = false
        }
    }

    // MARK: - Properties

    fileprivate var data: [ProductDetailsObject] = []
    fileprivate var selectedProducts: [ProductDetailsObject] {
        return Array(selectedProductsDict.values)
    }
    fileprivate var selectedProductsDict: [String: ProductDetailsObject] = [:]
    var sortType: SortType = .ascending

    var shouldEnable: Bool = false {
        didSet {
            buyNowButton.isEnabled = shouldEnable
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
      
        NotificationCenter.default.addObserver(self, selector: #selector(showResponseInfo), name: NSNotification.Name("webViewResponse"), object: nil)
        
        setupInitialData()
        setupCollectionView()
        setupBackButton()
        setupThemedNavbar()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarLargeTitleTheme(title: "Featured", color: UIColor(named: "app_theme_color") ?? UIColor.red)
        setupNavBarTitleTheme()
    }

    @objc func showResponseInfo(_ notification: Notification) {
        if let webViewResponse = notification.object as? WebViewResponse {
            let isSuccess: Bool = (webViewResponse.status == "Success") || (webViewResponse.isSuccess == "true")
            showSwiftResponseMessagesView(isSuccess: isSuccess, webViewResponse: webViewResponse)
        }
    }
    
    func showSwiftResponseMessagesView(isSuccess: Bool = false, webViewResponse: WebViewResponse) {
        DispatchQueue.main.async {
            guard let view = Bundle.main.loadNibNamed("ResponseView", owner: nil, options: nil)?.first as? ResponseView  else { return }
            view.delegate = self
            view.setLayout(isSuccess: isSuccess, amount: self.formattedSummaryText, webViewResponse)
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .center
            config.presentationContext = .window(windowLevel: .normal)
            config.duration = .forever
            config.dimMode = .gray(interactive: true)
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    func showSwiftMessagesView(isSuccess: Bool = false) {
        DispatchQueue.main.async {
            guard let view = Bundle.main.loadNibNamed("SwiftAlertView", owner: nil, options: nil)?.first as? SwiftAlertView  else { return }
            view.delegate = self
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .center
            config.presentationContext = .window(windowLevel: .normal)
            config.duration = .forever
            config.dimMode = .gray(interactive: true)
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    func setupInitialData() {
        data = ShoppingDataManager.prepareShoppingData()
        prepareSortingData()
        infoLabel.text = "\(data.count) items listed"
    }

    func prepareSortingData() {
        switch sortType {
        case .ascending:
            data.sort(by: { $0.price ?? 0.0 < $1.price ?? 0.0 })
        case .descending:
            data.sort(by: { $0.price ?? 0.0 > $1.price ?? 0.0 })
        }
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }

    @IBAction func onClickSortButton(_ sender: UIButton) {
        switch sortType {
        case .ascending:
            sortType = .descending
        case .descending:
            sortType = .ascending
        }
        prepareSortingData()
        collectionView.reloadData()
    }

    @IBAction func onClickBuyNowButton(_ sender: UIBarButtonItem) {
        
        showSwiftView()
    }
}

// MARK: UICollectionViewDataSource

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.cellIdentifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let productData = data[indexPath.item]
        if selectedProductsDict[productData.id ?? ""] != nil {
            cell.layout(basedOn: productData, isSelected: true)
        } else {
            cell.layout(basedOn: productData, isSelected: false)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let productData = data[indexPath.item]

        let id = productData.id ?? ""
        if selectedProductsDict[id] != nil {
            selectedProductsDict.removeValue(forKey: id)
        } else {
            selectedProductsDict[id] = productData
        }
        shouldEnable = selectedProductsDict.count >= 1 ? true : false
        collectionView.reloadData()
    }
}

// MARK: - Extension that adds conformance to UICollectionViewDelegateFlowLayout

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset
        let itemSize = (collectionView.frame.width - (contentInset.left + contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

// MARK: - Extension that adds support for PinterestLayoutDelegate protocol

extension ProductListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let productData = data[indexPath.item]
        return min(productData.image?.size.height ?? 300, 300)
    }
}

extension ProductListViewController: ResponseViewDelegate {
    func goBack(fromSuccess: Bool) {
//        if(fromSuccess) {
//            hideSwiftView()
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            hideSwiftView()
//        }
        hideSwiftView()
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductListViewController: SwiftAlertViewDelegate {
    
    func getTotalAmount() -> Int {
        let delivery: Double = 0
        let sumOfOrders = selectedProducts.map { $0.price ?? 0.0 }.reduce(0.0, +)
        return Int(sumOfOrders + delivery)
    }
    
    func prepareConfig() -> WebTransactionRequest {
        
        let billingAddress = BillingAddress(city: "VND", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
        
        let merchantDetails = MerchantDetails(name: "Downy", logo: "images/v184_135.png", backUrl: "https://demo.chaipay.io/checkout.html", promoCode: "Downy350", promoDiscount: 0, shippingCharges: 0.0)
        let billingDetails = BillingDetails(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: "+918341469169", billingAddress: billingAddress)
        
        
        let shippingAddress = ShippingAddress(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
        
        let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
        
        var orderDetails:  [OrderDetails] = []
        for details in self.selectedProducts {
            let product = OrderDetails(id: details.id ?? "", name: details.title ?? "", price: details.price ?? 0, quantity: 1, image: details.imageName ?? "")
            orderDetails.append(product)
        }
        
        let transactionRequest = WebTransactionRequest(chaipayKey: "aiHKafKIbsdUJDOb", merchantDetails: merchantDetails, merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))", amount: getTotalAmount(), currency: "VND", signatureHash: "123", billingAddress: billingDetails, shippingAddress: shippingDetails, orderDetails: orderDetails, successURL: "chaipay://", failureURL: "chaipay://", redirectURL: "chaipay://checkout", countryCode: "VN", expiryHours: 2, source: "api", description: "test dec", showShippingDetails: true, showBackButton: false, defaultGuestCheckout: false, isCheckoutEmbed: false )
        
        print(transactionRequest)
        return transactionRequest
    }
    
    func createJWTToken() -> String {
        
        struct Header: Encodable {
            let alg = "HS256"
            let typ = "JWT"
        }
        func generateCurrentTimeStamp (extraTime: Int = 0) -> Int {
            let currentTimeStamp = Date().timeIntervalSince1970 + TimeInterval(extraTime)
            let token = String(currentTimeStamp)
            return Int(currentTimeStamp)
        }
        struct Payload: Encodable {
            
            let iss = "CHAIPAY"
            let sub = "aiHKafKIbsdUJDOb"
            let iat = generateCurrentTimeStamp()
            let exp = generateCurrentTimeStamp(extraTime: 10000)
        }
        let secret = "2601efeb4409f7027da9cbe856c9b6b8b25f0de2908bc5322b1b352d0b7eb2f5"
        //let secret = "a3b8281f6f2d3101baf41b8fde56ae7f2558c28133c1e4d477f606537e328440"
        let privateKey = SymmetricKey(data: secret.data(using: .utf8)!)

        let headerJSONData = try! JSONEncoder().encode(Header())
        let headerBase64String = headerJSONData.urlSafeBase64EncodedString()

        let payloadJSONData = try! JSONEncoder().encode(Payload())
        let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

        let toSign = (headerBase64String + "." + payloadBase64String).data(using: .utf8)!

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
        return token
        
    }
    
    func checkOutUIClicked() {
        
        let token = createJWTToken()
        let config = prepareConfig()
        hideSwiftView()
        checkout?.checkOutUI(config: config, jwtToken: token, onCompletionHandler: { (result) in
            switch result{
            case .success(let data):
                print("Data", data)
            case .failure(let error):
                print("error", error)
            }
        })
    }
    
    func hideSwiftView() {
        SwiftMessages.hide()
    }
    
    func showSwiftView() {
        showSwiftMessagesView()
    }
    
    func customUIClicked() {
        let productDetailsViewController: ProductDetailsViewController = ViewControllersFactory.viewController()
        productDetailsViewController.selectedProductsDict = selectedProductsDict
        productDetailsViewController.checkout = checkout
        hideSwiftView()
        self.navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    
}


