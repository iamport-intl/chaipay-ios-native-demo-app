//
//  PaymentMethodDataSource.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 06/09/21.
//

import Foundation
import ChaiPayPaymentSDK
import UIKit

enum PaymentMethodType {
    case wallet
    case newCreditCard
    case savedCards
    case otherPayments

    var title: String {
        switch self {
        case .otherPayments:
            return "Other Payments"
        case .savedCards:
            return "Saved Cards"
        case .wallet:
            return "Wallets"
        case .newCreditCard:
            return "New Credit Card"
        }
    }

    var image: UIImage? {
        switch self {
        case .otherPayments:
            return UIImage(named: "wallet")
        case .savedCards:
            return UIImage(named: "wallet")
        case .wallet:
            return UIImage(named: "wallet")
        case .newCreditCard:
            return UIImage(named: "wallet")
        }
    }
}

struct PaymentMethodDataSource {
    var type: PaymentMethodType = .otherPayments
    var paymentMethods: [PaymentMethodObject] = []
    var cardPayments: [SavedCard] = []
    var isExpanded: Bool = false
}
