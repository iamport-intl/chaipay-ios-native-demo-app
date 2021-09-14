# chaipay-ios-native-demo-app
# iOS Native Payment SDK V2

### Steps to integrate iOS SDK:

- Download the framework from [here](https://github.com/iamport-intl/chaipay-ios-native-frameworks.git)
- After downloading the .xcframework, drag and drop it in the project
    - Go to General → Frameworks, Library and Embedded Content and then drop the framework and change the Embed to Embed & sign.

    ![Screenshot 2021-09-03 at 10.50.31 AM.png](iOS%20Native%20Payment%20SDK%20V2%20249664c735754d06965583fd2648f5d1/Screenshot_2021-09-03_at_10.50.31_AM.png)

- Import the ChaiPayPaymentSDK as below at the required places.

    ```swift
    import ChaiPayPaymentSDK
    ```

- Initialise the checkout instance to get the available methods in SDK as below

    ```swift
    var checkout = Checkout(environmentType: .dev, redirectURL: "chaipay://", delegate: self)
    ```

- Set the environment as .dev to test in the dev environment. While moving to the Production, set the environment to .prod(default to .prod).
- Should implement the delegate methods as below get the response of failure and success callbacks from the webView.

    ```swift
     extension ViewController: CheckoutDelegate {
        func transactionResponse(_ webViewResponse: WebViewResponse?) {
            if let response = webViewResponse {
    						 // Do the needful with redponse
            }
        }

    		var viewController: UIViewController? {
            return self
        }
    }
    ```

- In the info.plist add the new Array type node LSApplicationQueriesSchemes as below:

    ```swift
    <key>LSApplicationQueriesSchemes</key>
    	<array>
    		<string>itms-appss</string>
    		<string>momo</string>
    		<string>zalopay</string>
    		<string>chaipay</string>
    	</array>
    ```

    ![Screenshot 2021-09-03 at 2.30.38 PM.png](iOS%20Native%20Payment%20SDK%20V2%20249664c735754d06965583fd2648f5d1/Screenshot_2021-09-03_at_2.30.38_PM.png)

- Include the URLType in info.plist to redirect to your app(deep linking) as below

    ```swift
    <key>CFBundleURLTypes</key>
    	<array>
    		<dict>
    			<key>CFBundleTypeRole</key>
    			<string>Editor</string>
    			<key>CFBundleURLName</key>
    			<string>checkout</string>
    			<key>CFBundleURLSchemes</key>
    			<array>
    				<string>chaipay</string>
    			</array>
    		</dict>
    	</array>
    ```

    ![Screenshot 2021-09-03 at 2.35.35 PM.png](iOS%20Native%20Payment%20SDK%20V2%20249664c735754d06965583fd2648f5d1/Screenshot_2021-09-03_at_2.35.35_PM.png)

### Fetch the saved cards for a particular number

- Capture the mobile number and OTP to fetch the saved credit cards for a particular user.
- To generate the OTP, call the method as below:

```swift
checkOut?.getOTP(self.numberTextField.text ?? "") {result in
            switch result {
            case .success(let data):
                print("data" , data)
            case .failure(let error):
                print("error", error)
                break
            }
            
        }
```

data -   Contains data, status.

**Status code** :

200 - Success

400 - Failed due to incorrect OTP or wrong params passed

4. After successfully entered the OTP, the captured mobile number and OTP should pass to the *fetchSavedCards* as below to fetch the saved credit cards for the particular number.

```swift
checkOut?.fetchSavedCards(self.formattedText ?? "", otp: self.OTP ?? "") {result in
            switch result {
            case .success(let data):
                //Do the needful
                
            case .failure(let error):
								//handle the error cases
            }
        }
```

**formattedText** - Contains mobile number with Country code. (eg: ⁨‭+16625655248 , +918341234123)

**OTP** - OTP that received to the particular number given.

response:

**Success case**

```jsx
"data": [
        {
            "token": "5ff6644dec554fdc8f6d2e161a0c662d",
            "partial_card_number": "450875******1019",
            "expiry_month": "05",
            "expiry_year": "2021",
            "type": "visa"
        },
         {
            "token": "5ff6644dec554fdc8f6d2e161a0c662d",
            "partial_card_number": "450875******1019",
            "expiry_month": "05",
            "expiry_year": "2021",
            "type": "visa"
        }
],
    "status": 200,
    }
```

**Failure case:**

```jsx
{
"message": "OTP is a required Query Param!",
"status": 400,
}
```

### **Can make the payments in the following ways:**

- Initiate with wallet payment
- Initiate with new credit card Payment
- Initiate from saved credit card payment

***Initiate the wallet Payment***

- Initialise the wallet payment with *transactionRequest* as below:

    ```swift
    func prepareConfig(type: PaymentMethod) -> TransactionRequest {
            
    				let billingAddress = BillingAddress(city: "VND", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
            let billingDetails = BillingDetails(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: "+918341469169", billingAddress: billingAddress )
            
            let shippingAddress = ShippingAddress(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
            let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
            
            let orderDetails = OrderDetails(id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
            
            return TransactionRequest(
                  chaipayKey: "lzrYFPfyMLROallZ", 
    							paymentChannel: type.paymentMethod, //"ZALOPAY" 
    							paymentMethod: type.paymentMethod, //"ZALOPAY_WALLET"
    							merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))", 
    							amount: 180000, 
    							currency: "VND", 
    							signatureHash: "123",
    							billingAddress: billingDetails, 
    							shippingAddress: shippingDetails, 
    							orderDetails: [orderDetails],  
    							successURL: "chaipay://", 
    							failureURL: "chaipay://", 
    							redirectURL: "chaipay://"
            )
        }
    ```

- Pass the *TransactionRequest to initiateWalletPayments as below:*

    ```swift
    let config = prepareConfig(type: .ZaloPay)

    checkOut?.initiateWalletPayments(config) { result in
                switch result {
                case .success(let data):
                    // Do nothing
                case .failure(let error):
                   // Handle the error part 
    							   print("error", error)
                     break
                }
            }
    ```

    Handle the success and failure cases from the delegate method as below:

    ```swift
    extension ViewController: CheckoutDelegate {
        func transactionResponse(_ webViewResponse: WebViewResponse?) {
            if let response = webViewResponse {
                //Todo: Polulate date or do the needful
            }
        }
    }
    ```

    Sample Payload request: 

    ```swift
    var payload = {
        chaipayKey: "lzrYFPfyMLROallZ",
        paymentChannel: ZALOPAY,
        paymentMethod: ZALOPAY_WALLET,
        merchantOrderId: 'MERCHANT1628666326578',
        amount: 4499999,
        currency: "VND",
        signature_hash:"+qGV+YhWEituu7Cf0coqdEgLtcH6qWKXXMDLI2jhxQU=",
        orderDetails: [
          {
            "id": "knb",
            "name": "kim nguyen bao",
            "price": 4499999,
            "quantity": 1
          }
        ],
       billingAddress: {
            billing_name: "Test mark",
            billing_email: "markweins@gmail.com",
            billing_phone: "+919998878788",
            billing_address: {
              city: "VND",
              country_code: "VN",
              locale: "en",
              line_1: "address",
              line_2: "address_2",
              postal_code: "400202",
              state: "Mah",
            },
          },
        shippingAddress: {
            shipping_name: "xyz",
            shipping_email: "xyz@gmail.com",
            shipping_phone: "1234567890",
            shipping_address: {
              city: "abc",
              country_code: "VN",
              locale: "en",
              line_1: "address_1",
              line_2: "address_2",
              postal_code: "400202",
              state: "Mah",
            },
          },
      };
    ```

    ### **Sample response**

    ***Success callback :***

    ```jsx
    {
      "chaipay_order_ref": "1wc00XMK4uKy3EeYBAvRPlkfjkZ",
      "channel_order_ref": "210812000000171",
      "merchant_order_ref": "MERCHANT1628742344516",
      "status": "Success",
      "status_code": "2000",
      "status_reason": "SUCCESS"
    }
    ```

    ***Failure Callback***:

    ```jsx
    {
      "chaipay_order_ref": "1wa0choxhAy2QtE9ix8aNt8T3Mf",
      "channel_order_ref": "0",
      "merchant_order_ref": "MERCHANT1628681469666",
      "status": "Initiated",
      "status_code": "4000",
      "status_reason": "INVALID_TRANSACTION_ERROR"
    }
    ```

    **Steps for Signature Hash Generation**[Payment Request](https://www.docs.chaipay.io/getting_started/signatures/payment_request.html)

    ***Initiate with new credit card Payment***

    - Initialise the new card payment with *transactionRequest* as below:

        ```swift
        func prepareConfig(type: PaymentMethod) -> TransactionRequest {
                
        				let billingAddress = BillingAddress(city: "VND", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
                let billingDetails = BillingDetails(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: "+918341469169", billingAddress: billingAddress )
                
                let shippingAddress = ShippingAddress(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
                let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
                
                let orderDetails = OrderDetails(id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
                
                return TransactionRequest(
                      chaipayKey: "lzrYFPfyMLROallZ", 
        							paymentChannel: type.paymentMethod, //"MASTERCARD" 
        							paymentMethod: type.paymentMethod, //"MASTERCARD_CARD"
        							merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))", 
        							amount: 180000, 
        							currency: "VND", 
        							signatureHash: "123",
        							billingAddress: billingDetails, 
        							shippingAddress: shippingDetails, 
        							orderDetails: [orderDetails],  
        							successURL: "chaipay://", 
        							failureURL: "chaipay://", 
        							redirectURL: "chaipay://"
                      )
            }
        ```

    - cardDetails:

        ```swift
        let cardDetails = CardDetails(token: nil, cardNumber: "5111111111111118", expiryMonth: "05", expiryYear: "2021", cardHolderName: "NGUYEN VAN A", type: "visa", cvv: "100")
                let config = prepareConfig(type: PaymentMethod.NewCreditCard
        ```

    - Pass the *TransactionRequest and cardDetails* to *initiateNewCardPayment* as below*:*

        ```swift
        let config = prepareConfig(type: .NewCreditCard)

        checkOut?.initiateNewCardPayment(config, cardDetails: cardDetails) { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success(let response):
        								// Do the needful with the response
        	
                    case .failure(let error):
        								// Handle the error cases
                    }
                }
        ```

        Handle the success and failure cases from the delegate method as below:

        ```swift
        extension ViewController: CheckoutDelegate {
            func transactionResponse(_ webViewResponse: WebViewResponse?) {
                if let response = webViewResponse {
                    //Todo: Polulate date or do the needful
                }
            }
        }
        ```

        Sample Payload request: 

        ```swift
        var payload = {
            chaipayKey: "lzrYFPfyMLROallZ",
            paymentChannel: MASTERCARD,
            paymentMethod: MASTERCARD_CARD,
            merchantOrderId: 'MERCHANT1628666326578',
            amount: 4499999,
            currency: "VND",
            signature_hash:"+qGV+YhWEituu7Cf0coqdEgLtcH6qWKXXMDLI2jhxQU=",
            orderDetails: [
              {
                "id": "knb",
                "name": "kim nguyen bao",
                "price": 4499999,
                "quantity": 1
              }
            ],
           billingAddress: {
                billing_name: "Test mark",
                billing_email: "markweins@gmail.com",
                billing_phone: "+919998878788",
                billing_address: {
                  city: "VND",
                  country_code: "VN",
                  locale: "en",
                  line_1: "address",
                  line_2: "address_2",
                  postal_code: "400202",
                  state: "Mah",
                },
              },
            shippingAddress: {
                shipping_name: "xyz",
                shipping_email: "xyz@gmail.com",
                shipping_phone: "1234567890",
                shipping_address: {
                  city: "abc",
                  country_code: "VN",
                  locale: "en",
                  line_1: "address_1",
                  line_2: "address_2",
                  postal_code: "400202",
                  state: "Mah",
                },
              },
          };
        ```

        ### **Sample response**

        *Sample **Success callback :***

        ```jsx

        {
          "merchant_order_ref" : "MERCHANT1630665361511",
          "message" : "",
          "is_success" : "true",
          "order_ref" : "1xcrkpVPNq5vuqQDe3eqrHD3OcG",
          "deep_link" : "",
          "channel_order_ref" : "1xcrkpVPNq5vuqQDe3eqrHD3OcG",
          "additional_data" : null,
          "redirect_url" : ""
        }
        ```

        *Sample **Failure Callback***:

        ```jsx
        {
          "chaipay_order_ref": "1wa0choxhAy2QtE9ix8aNt8T3Mf",
          "channel_order_ref": "0",
          "merchant_order_ref": "MERCHANT1628681469666",
          "status": "Initiated",
          "status_code": "4000",
          "status_reason": "INVALID_TRANSACTION_ERROR"
        }
        ```

        **Steps for Signature Hash Generation**[Payment Request](https://www.docs.chaipay.io/getting_started/signatures/payment_request.html)

        ### Initiate with Saved credit card Payment

    - Initialise the saved card payment with *transactionRequest* as below:

        ```swift
        func prepareConfig(type: PaymentMethod) -> TransactionRequest {
                
        				let billingAddress = BillingAddress(city: "VND", countryCode: "VN", locale: "en", line1: "address1", line2: "address2", postalCode: "400202", state: "Mah")
                let billingDetails = BillingDetails(billingName: "Test mark", billingEmail: "markweins@gmail.com", billingPhone: "+918341469169", billingAddress: billingAddress )
                
                let shippingAddress = ShippingAddress(city: "abc", countryCode: "VN", locale: "en", line1: "address_1", line2: "address_2", postalCode: "400202", state: "Mah")
                let shippingDetails = ShippingDetails(shippingName: "xyz", shippingEmail: "xyz@gmail.com", shippingPhone: "1234567890", shippingAddress: shippingAddress)
                
                let orderDetails = OrderDetails(id: "knb", name: "kim nguyen bao", price: 1000, quantity: 1)
                
                return TransactionRequest(
                      chaipayKey: "lzrYFPfyMLROallZ", 
        							paymentChannel: type.paymentMethod, //"MASTERCARD" 
        							paymentMethod: type.paymentMethod, //"MASTERCARD_CARD"
        							merchantOrderId: "MERCHANT\(Int(Date().timeIntervalSince1970 * 1000))", 
        							amount: 180000, 
        							currency: "VND", 
        							signatureHash: "123",
        							billingAddress: billingDetails, 
        							shippingAddress: shippingDetails, 
        							orderDetails: [orderDetails],  
        							successURL: "chaipay://", 
        							failureURL: "chaipay://", 
        							redirectURL: "chaipay://"
                )
            }
        ```

    - cardDetails:

        ```swift
        let cardDetails = CardDetails(token: savedCard.token, cardNumber: savedCard.partialCardNumber, expiryMonth: savedCard.expiryMonth, expiryYear: savedCard.expiryYear, cardHolderName: "", type: savedCard.type, cvv: "100")
        let config = prepareConfig(type: PaymentMethod.NewCreditCard)
        ```

    - Pass the *TransactionRequest and cardDetails* to *initiateNewCardPayment* as below*:*

        ```swift
        let config = prepareConfig(type: .SavedCard)

        checkOut?.initiateNewCardPayment(config, cardDetails: cardDetails) { [weak self] result in
                    guard let self = self else {
                        return
                    }
                    switch result {
                    case .success(let response):
        								// Do the needful with the response
        	
                    case .failure(let error):
        								// Handle the error cases
                    }
                }
        ```

        Handle the success and failure cases from the delegate method as below:

        ```swift
        extension ViewController: CheckoutDelegate {
            func transactionResponse(_ webViewResponse: WebViewResponse?) {
                if let response = webViewResponse {
                    //Todo: Polulate date or do the needful
                }
            }
        }
        ```

        Sample Payload request: 

        ```swift
        var payload = {
            chaipayKey: "lzrYFPfyMLROallZ",
            paymentChannel: MASTERCARD,
            paymentMethod: MASTERCARD_CARD,
            merchantOrderId: 'MERCHANT1628666326578',
            amount: 4499999,
            currency: "VND",
            signature_hash:"+qGV+YhWEituu7Cf0coqdEgLtcH6qWKXXMDLI2jhxQU=",
            orderDetails: [
              {
                "id": "knb",
                "name": "kim nguyen bao",
                "price": 4499999,
                "quantity": 1
              }
            ],
           billingAddress: {
                billing_name: "Test mark",
                billing_email: "markweins@gmail.com",
                billing_phone: "+919998878788",
                billing_address: {
                  city: "VND",
                  country_code: "VN",
                  locale: "en",
                  line_1: "address",
                  line_2: "address_2",
                  postal_code: "400202",
                  state: "Mah",
                },
              },
            shippingAddress: {
                shipping_name: "xyz",
                shipping_email: "xyz@gmail.com",
                shipping_phone: "1234567890",
                shipping_address: {
                  city: "abc",
                  country_code: "VN",
                  locale: "en",
                  line_1: "address_1",
                  line_2: "address_2",
                  postal_code: "400202",
                  state: "Mah",
                },
              },
          };
        ```

        ### **Sample response**

        *Sample **Success callback :***

        ```jsx

        {
          "merchant_order_ref" : "MERCHANT1630665361511",
          "message" : "",
          "is_success" : "true",
          "order_ref" : "1xcrkpVPNq5vuqQDe3eqrHD3OcG",
          "deep_link" : "",
          "channel_order_ref" : "1xcrkpVPNq5vuqQDe3eqrHD3OcG",
          "additional_data" : null,
          "redirect_url" : ""
        }
        ```

        *Sample **Failure Callback***:

        ```jsx
        {
          "chaipay_order_ref": "1wa0choxhAy2QtE9ix8aNt8T3Mf",
          "channel_order_ref": "0",
          "merchant_order_ref": "MERCHANT1628681469666",
          "status": "Initiated",
          "status_code": "4000",
          "status_reason": "INVALID_TRANSACTION_ERROR"
        }
        ```

        **Steps for Signature Hash Generation**[Payment Request](https://www.docs.chaipay.io/getting_started/signatures/payment_request.html)
