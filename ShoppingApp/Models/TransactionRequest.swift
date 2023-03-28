//
//  TransactionRequest.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 27/07/22.
//

import Foundation


public struct CardDetailsModal: Codable {
    public var token: String?
    public var cardNumber: String
    public var expiryMonth: String
    public var expiryYear: String
    public var type: String
    public var cardHolderName: String
    public var cvv: String
    public var savedCard: Bool

    public enum CodingKeys: String, CodingKey {
        case token = "token"
        case cardNumber = "partial_card_number"
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case type = "type"
        case cardHolderName = "card_holder_name"
        case cvv
        case savedCard = "save_card"
    }
    
    public init(token: String?,
                cardNumber: String,
                expiryMonth: String,
                expiryYear: String,
                cardHolderName: String,
                type: String,
                cvv: String,
                savedCard: Bool = false
    ) {
        self.token = token
        self.cardNumber = cardNumber
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cardHolderName = cardHolderName
        self.type = type
        self.cvv = cvv
        self.savedCard = savedCard
    }
}

public struct CardRequestObject: Codable {
    public var cardToken: String?
    public var cardNumber: String
    public var cardType: String
    public var cardholderName: String
    public var serviceCode: String
    public var expirationMonth: String
    public var expirationYear: String
    
    public enum CodingKeys: String, CodingKey {
        case cardToken = "card_token"
        case cardNumber = "card_number"
        case cardType = "card_type"
        case cardholderName = "cardholder_name"
        case serviceCode = "service_code"
        case expirationMonth = "expiration_month"
        case expirationYear = "expiration_year"
    }
    
    public init(cardNumber: String,
                cardType: String,
                cardholderName: String,
                serviceCode: String,
                expirationMonth: String,
                expirationYear: String
    ) {
        self.cardNumber = cardNumber
        self.cardType = cardType
        self.cardholderName = cardholderName
        self.serviceCode = serviceCode
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
    }
}
extension CardRequestObject {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cardToken = try container.decode(String.self, forKey: .cardToken)
        cardNumber = try container.decode(String.self, forKey: .cardNumber)
        cardType = try container.decode(String.self, forKey: .cardType)
        cardholderName = try container.decode(String.self, forKey: .cardholderName)
        serviceCode = try container.decode(String.self, forKey: .serviceCode)
        expirationMonth = try container.decode(String.self, forKey: .expirationMonth)
        expirationYear = try container.decode(String.self, forKey: .expirationYear)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(cardType, forKey: .cardType)
        try container.encode(cardholderName, forKey: .cardholderName)
        try container.encode(serviceCode, forKey: .serviceCode)
        try container.encode(expirationMonth, forKey: .expirationMonth)
        try container.encode(expirationYear, forKey: .expirationYear)
    }
}

public struct TokenRequestObject: Codable {
    public var card: CardRequestObject
    
    public enum CodingKeys: String, CodingKey {
        case card = "card"
    }
    
    public init(card: CardRequestObject) {
        self.card = card
    }
}
extension TokenRequestObject {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        card = try container.decode(CardRequestObject.self, forKey: .card)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(card, forKey: .card)
    }
}

public struct TokenResponseObject: Codable {
    public var type : String
    public var id: String
    public var attributes: CardRequestObject
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case attributes = "attributes"
    }
    
    enum DataCodingKeys: String, CodingKey {
        case data = "data"
    }
}
extension TokenResponseObject {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataCodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        type = try dataContainer.decode(String.self, forKey: .type)
        id = try dataContainer.decode(String.self, forKey: .id)
        attributes = try dataContainer.decode(CardRequestObject.self, forKey: .attributes)
    }
}
    
public class TransactionRequestModal: Codable {
    public var chaipayKey: String
    public var merchantDetails: MerchantDetailsModal
    public var paymentChannel: String
    public var paymentMethod: String
    public var merchantOrderId: String
    public var amount: Int
    public var currency: String?
    public var signatureHash: String
    public var billingAddress: BillingDetailsModal
    public var shippingAddress: ShippingDetailsModal
    public var orderDetails: [OrderDetailsModal]
    public var successURL: String?
    public var failureURL: String?
    public var redirectURL: String?
    public var tokenParams: CardDetailsModal?
    public var countryCode: String
    public var environment: String
    
    public enum CodingKeys: String, CodingKey {
        case chaipayKey = "key"
        case merchantDetails = "merchantDetails"
        case paymentChannel = "paymentChannel"
        case paymentMethod = "paymentMethod"
        case merchantOrderId = "merchantOrderId"
        case amount = "amount"
        case currency = "currency"
        case successURL = "successUrl"
        case failureURL = "failureUrl"
        case redirectURL = "redirectUrl"
        case signatureHash = "signatureHash"
        case billingAddress = "billingAddress"
        case shippingAddress = "shippingAddress"
        case orderDetails = "orderDetails"
        case tokenParams = "tokenParams"
        case countryCode = "countryCode"
        case environment = "environment"
    }
    
    public init(chaipayKey: String,
                merchantDetails: MerchantDetailsModal,
                paymentChannel: String,
                paymentMethod: String,
                merchantOrderId: String,
                amount: Int,
                currency: String,
                signatureHash: String,
                billingAddress: BillingDetailsModal,
                shippingAddress: ShippingDetailsModal,
                orderDetails: [OrderDetailsModal],
                successURL: String,
                failureURL: String,
                redirectURL: String,
                countryCode: String,
                environment: String
    ) {
        self.chaipayKey = chaipayKey
        self.merchantDetails = merchantDetails
        self.environment = environment
        self.paymentChannel = paymentChannel
        self.paymentMethod = paymentMethod
        self.merchantOrderId = merchantOrderId
        self.amount = amount
        self.currency = currency
        self.signatureHash = signatureHash
        self.billingAddress = billingAddress
        self.shippingAddress = shippingAddress
        self.orderDetails = orderDetails
        self.successURL = successURL
        self.failureURL = failureURL
        self.redirectURL = redirectURL
        self.countryCode = countryCode
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chaipayKey = try container.decode(String.self, forKey: .chaipayKey)
        environment = try container.decode(String.self, forKey: .environment)
        paymentChannel = try container.decode(String.self, forKey: .paymentChannel)
        paymentMethod = try container.decode(String.self, forKey: .paymentMethod)
        merchantOrderId = try container.decode(String.self, forKey: .merchantOrderId)
        amount = try container.decode(Int.self, forKey: .amount)
        currency = try container.decode(String.self, forKey: .currency)
        successURL = try container.decode(String.self, forKey: .successURL)
        failureURL = try container.decode(String.self, forKey: .failureURL)
        redirectURL = try container.decode(String.self, forKey: .redirectURL)
        signatureHash = try container.decode(String.self, forKey: .signatureHash)
        billingAddress = try container.decode(BillingDetailsModal.self, forKey: .billingAddress)
        shippingAddress = try container.decode(ShippingDetailsModal.self, forKey: .shippingAddress)
        orderDetails = try container.decode([OrderDetailsModal].self, forKey: .orderDetails)
        tokenParams = try container.decode(CardDetailsModal.self, forKey: .tokenParams)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        merchantDetails = try container.decode(MerchantDetailsModal.self, forKey: .merchantDetails)
        
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chaipayKey, forKey: .chaipayKey)
        try container.encode(environment, forKey: .environment)
        try container.encode(paymentChannel, forKey: .paymentChannel)
        try container.encode(paymentMethod, forKey: .paymentMethod)
        try container.encode(merchantOrderId, forKey: .merchantOrderId)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(successURL, forKey: .successURL)
        try container.encode(failureURL, forKey: .failureURL)
        try container.encode(signatureHash, forKey: .signatureHash)
        try container.encode(billingAddress, forKey: .billingAddress)
        try container.encode(shippingAddress, forKey: .shippingAddress)
        try container.encode(orderDetails, forKey: .orderDetails)
        try container.encode(redirectURL, forKey: .redirectURL)
        try container.encode(tokenParams, forKey: .tokenParams)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(merchantDetails, forKey: .merchantDetails)
        

    }
}

public struct BillingDetailsModal: Codable {
    public var billingName: String?
    public var billingEmail: String?
    public var billingPhone: String?
    public var billingAddress: BillingAddressModal?
    
    public enum CodingKeys: String, CodingKey {
        case billingName = "billing_name"
        case billingEmail = "billing_email"
        case billingPhone = "billing_phone"
        case billingAddress = "billing_address"
    }
    
    public init(billingName: String,
                billingEmail: String,
                billingPhone: String,
                billingAddress: BillingAddressModal
    ) {
        self.billingName = billingName
        self.billingEmail = billingEmail
        self.billingPhone = billingPhone
        self.billingAddress = billingAddress
    }
}

extension BillingDetailsModal {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        billingName = try container.decode(String.self, forKey: .billingName)
        billingEmail = try container.decode(String.self, forKey: .billingEmail)
        billingPhone = try container.decode(String.self, forKey: .billingPhone)
        billingAddress = try container.decode(BillingAddressModal.self, forKey: .billingAddress)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(billingName, forKey: .billingName)
        try container.encode(billingEmail, forKey: .billingEmail)
        try container.encode(billingPhone, forKey: .billingPhone)
        try container.encode(billingAddress, forKey: .billingAddress)
    }
}

public struct BillingAddressModal: Codable {
    public var city: String?
    public var countryCode: String?
    public var locale: String?
    public var line1: String?
    public var line2: String?
    public var postalCode: String?
    public var state: String?
    
    public enum CodingKeys: String, CodingKey {
        case city = "city"
        case countryCode = "country_code"
        case locale = "locale"
        case line1 = "line_1"
        case line2 = "line_2"
        case postalCode = "postal_code"
        case state = "state"
    }
    
    public init(city: String,
                countryCode: String,
                locale: String,
                line1: String,
                line2: String,
                postalCode: String,
                state: String
    ) {
        self.city = city
        self.countryCode = countryCode
        self.locale = locale
        self.line1 = line1
        self.line2 = line2
        self.postalCode = postalCode
        self.state = state
    }
}

extension BillingAddressModal {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(String.self, forKey: .city)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        locale = try container.decode(String.self, forKey: .locale)
        line1 = try container.decode(String.self, forKey: .line1)
        line2 = try container.decode(String.self, forKey: .line2)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        state = try container.decode(String.self, forKey: .state)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(city, forKey: .city)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(locale, forKey: .locale)
        try container.encode(line1, forKey: .line1)
        try container.encode(line2, forKey: .line2)
        try container.encode(postalCode, forKey: .postalCode)
        try container.encode(state, forKey: .state)
    }
}

public struct ShippingDetailsModal: Codable {
    public var shippingName: String?
    public var shippingEmail: String?
    public var shippingPhone: String?
    public var shippingAddress: ShippingAddressModal?
    
    public enum CodingKeys: String, CodingKey {
        case shippingName = "shipping_name"
        case shippingEmail = "shipping_email"
        case shippingPhone = "shipping_phone"
        case shippingAddress = "shipping_address"
    }
    
    public init(shippingName: String,
                shippingEmail: String,
                shippingPhone: String,
                shippingAddress: ShippingAddressModal
    ) {
        self.shippingName = shippingName
        self.shippingEmail = shippingEmail
        self.shippingPhone = shippingPhone
        self.shippingAddress = shippingAddress
    }
}


extension ShippingDetailsModal {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shippingName = try container.decode(String.self, forKey: .shippingName)
        shippingEmail = try container.decode(String.self, forKey: .shippingEmail)
        shippingPhone = try container.decode(String.self, forKey: .shippingPhone)
        shippingAddress = try container.decode(ShippingAddressModal.self, forKey: .shippingAddress)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shippingName, forKey: .shippingName)
        try container.encode(shippingEmail, forKey: .shippingEmail)
        try container.encode(shippingPhone, forKey: .shippingPhone)
        try container.encode(shippingAddress, forKey: .shippingAddress)
    }
}

public struct ShippingAddressModal: Codable {
    public var city: String?
    public var countryCode: String?
    public var locale: String?
    public var line1: String?
    public var line2: String?
    public var postalCode: String?
    public var state: String?
    
    public enum CodingKeys: String, CodingKey {
        case city = "city"
        case countryCode = "country_code"
        case locale = "locale"
        case line1 = "line_1"
        case line2 = "line_2"
        case postalCode = "postal_code"
        case state = "state"
    }
    
    public init(city: String,
                countryCode: String,
                locale: String,
                line1: String,
                line2: String,
                postalCode: String,
                state: String
    ) {
        self.city = city
        self.countryCode = countryCode
        self.locale = locale
        self.line1 = line1
        self.line2 = line2
        self.postalCode = postalCode
        self.state = state
    }
}

extension ShippingAddressModal {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(String.self, forKey: .city)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        locale = try container.decode(String.self, forKey: .locale)
        line1 = try container.decode(String.self, forKey: .line1)
        line2 = try container.decode(String.self, forKey: .line2)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        state = try container.decode(String.self, forKey: .state)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(city, forKey: .city)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(locale, forKey: .locale)
        try container.encode(line1, forKey: .line1)
        try container.encode(line2, forKey: .line2)
        try container.encode(postalCode, forKey: .postalCode)
        try container.encode(state, forKey: .state)
    }
}

public struct OrderDetailsModal: Codable {
    public var id: String?
    public var name: String?
    public var price: Double?
    public var quantity: Int?
    public var imageUrl: String?
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case quantity = "quantity"
        case imageUrl = "image"
    }
    
    public init(id: String,
                name: String,
                price: Double,
                quantity: Int,
                imageUrl: String
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.imageUrl = imageUrl
    }
}

extension OrderDetailsModal {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        quantity = try container.decode(Int.self, forKey: .quantity)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(imageUrl, forKey: .imageUrl)
    }
}

public struct MerchantDetailsModal: Codable {
    public var name: String
    public var logo: String
    public var backUrl: String
    public var promoCode: String
    public var promoDiscount: Int
    public var shippingCharges: Double
    
    public enum CodingKeys: String, CodingKey {
        case name = "name"
        case logo = "logo"
        case backUrl = "back_url"
        case promoCode = "promo_code"
        case promoDiscount = "promo_discount"
        case shippingCharges = "shipping_charges"
    }
    
    public init(name: String,
                logo: String,
                backUrl: String,
                promoCode: String,
                promoDiscount: Int,
                shippingCharges: Double
    ) {
        self.name = name
        self.logo = logo
        self.backUrl = backUrl
        self.promoCode = promoCode
        self.promoDiscount = promoDiscount
        self.shippingCharges = shippingCharges
    }
}
