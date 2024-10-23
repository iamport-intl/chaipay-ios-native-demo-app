//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//


import UIKit
import PortoneSDK
import CryptoKit

struct ProductDetailsObject {
    var id: String?
    var title: String?
    var description: String?
    var price: Double?
    var currency: String?
    var imageName: String?
    var image: UIImage? {
        return UIImage(named: imageName ?? "")
    }
}
class MerchantViewController: UIViewController {

    var checkout: Checkout? // Declare the Checkout instance
    
    let jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiQ2t0enliSE9xeWZUanJwIiwiaXNzIjoiUE9SVE9ORSIsImlhdCI6MTcyOTY2ODIwNiwiZXhwIjoxODI5NjY4MjA2fQ.wMgz9NpVh2t77uc6djfiO-rbGkTaCDtF-I3bsAHgHB8"
    let portoneKy = "bCktzybHOqyfTjrp"
    let secretKey = "17fd4b860101361129e5bc3d26b7c8ff80d47f7d514e8eba66e9c95f5321b123"
    @IBOutlet weak var transactionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up UI components programmatically (UILabel and UIButton)
        setupUI()

        // Initialize the Checkout instance
        checkout = Checkout(delegate: self,
                            environment: "sandbox",
                            redirectURL: "portone://checkout",
                            appIdentifier: "com.flutter.portone")
        checkout?.changeEnvironment(envType: "dev")
    }

    // Set up UI components
    private func setupUI() {
        view.backgroundColor = .white
        
        // Title Label
        

        // Transaction Button
        
        transactionButton.setTitle("Start Portone Transaction", for: .normal)
        transactionButton.backgroundColor = .systemBlue
        transactionButton.setTitleColor(.white, for: .normal)
        transactionButton.layer.cornerRadius = 8
        transactionButton.translatesAutoresizingMaskIntoConstraints = false
        transactionButton.addTarget(self, action: #selector(startPortoneSDK), for: .touchUpInside)
        view.addSubview(transactionButton)

    }

    // Method to start the Portone SDK transaction
    @objc private func startPortoneSDK() {
        guard let checkout = checkout else {
            print("Checkout is not initialized.")
            return
        }

        let config = prepareConfig()
        checkout.checkOutUI(config: config, jwtToken: jwtToken, subMerchantKey: nil)
    }

    // Method to generate HMAC signature for Portone request
    func createWebHash(_ config: WebTransactionRequest) -> String {
        var message = """
        amount=\(Int(config.amount))&client_key=\(config.portOneKey.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        &currency=\(config.currency!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        &failure_url=\(config.failureURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        &merchant_order_id=\(config.merchantOrderId.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        &success_url=\(config.successURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        """

        let secretString = secretKey
        let key = SymmetricKey(data: secretString.data(using: .utf8)!)
        let signature = HMAC<SHA256>.authenticationCode(for: message.data(using: .utf8)!, using: key)
        let x = Data(signature).tob()
    }

    // Prepare transaction configuration
    private func prepareConfig() -> WebTransactionRequest {
        let earRings = ProductDetailsObject(id: MerchantViewController.randomString(), title: "Sririri Toes", description: "Special Design", price: 1, currency: "VND", imageName: "https://demo.portone.cloud/images/bella-toes.jpg")
        let scarf = ProductDetailsObject(id: MerchantViewController.randomString(), title: "Chikku Loafers", description: "Special Design", price: 15000, currency: "VND", imageName: "https://demo.portone.cloud/images/chikku-loafers.jpg")

        let selectedProducts = [earRings, scarf]
        let billingAddress = BillingAddress(city: "City", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")

        let merchantDetails = MerchantDetails(name: "Downy", logo: "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg", backUrl: "https://demo.chaiport.io/checkout.html", promoCode: "Downy350", promoDiscount: 0, shippingCharges: 0.0)
        let billingDetails = BillingDetails(billingName: "Test User", billingEmail: "testuser@gmail.com", billingPhone: "+660956425564", billingAddress: billingAddress)

        let shippingAddress = ShippingAddress(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
        let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)

        var orderDetails: [OrderDetails] = []
        for details in selectedProducts {
            let product = OrderDetails(id: details.id ?? "", name: details.title ?? "", price: details.price ?? 0, quantity: 1, imageUrl: details.imageName ?? "")
            orderDetails.append(product)
        }

        let delivery: Double = 0
        let sumOfOrders = selectedProducts.map { $0.price ?? 0.0 }.reduce(0.0, +)
        let totalAmount = sumOfOrders + delivery

        var transactionRequest = WebTransactionRequest(
            portOneKey: portoneKy,
            merchantDetails: merchantDetails,
            merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))",
            amount: totalAmount,
            currency: "VND",
            signatureHash: "123",
            billingAddress: billingDetails,
            shippingAddress: shippingDetails,
            orderDetails: orderDetails,
            successURL: "https://test-checkout.chaiport.io/success.html",
            failureURL: "https://test-checkout.chaiport.io/failure.html",
            redirectURL: "portone://checkout",
            countryCode: "VN",
            expiryHours: 2,
            source: "mobile",
            description: "test desc",
            showShippingDetails: true,
            showBackButton: false,
            defaultGuestCheckout: false,
            isCheckoutEmbed: false,
            environment: .sandbox
        )

        transactionRequest.signatureHash = createWebHash(transactionRequest)
        return transactionRequest
    }

    // Generate random string
    static func randomString(_ length: Int = 6) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}

extension MerchantViewController: CheckoutDelegate {
    
    var viewController: UIViewController? {
        return self
    }

    // This function will be called when the transaction response is received
    func transactionResponse(response: PortoneSDK.TransactionResponse?) {
        if let response = response {
            print("Transaction Response: \(response)")
            // Handle the successful transaction response here
        }
    }
    
    // This function will handle any errors during the transaction
    func transactionErrorResponse(error: Error?) {
        if let error = error {
            print("error", error)
            print("Transaction Error: \((error as? NetworkError)?.message)")
            // Handle the error response here
        }
    }
}
