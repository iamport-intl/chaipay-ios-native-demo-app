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
    case atm
    case bankTransfer
    case bnpl
    case netBanking
    case QRCode
    case creditDebitCards
    case COD
    case crypto
    case directBankTransfer
    case instalment

    var title: String {
        switch self {
        case .atm:
            return "ATM_card".localized
        case .savedCards:
            return "saved_cards".localized
        case .wallet:
            return "wallets".localized
        case .newCreditCard:
            return "credit_card".localized
        case .bankTransfer:
            return "Bank Transfer"
        case .bnpl:
            return "BNPL"
        case .netBanking:
            return "Net Banking"
        case .QRCode:
            return "QRCode"
        case .creditDebitCards:
            return "Credit and Debit Cards"
        case .COD:
            return "COD"
        case .crypto:
            return "Crypto"
        case .directBankTransfer:
            return "Direct bank Transfer"
        case .instalment:
            return "Instalment"
        }
    }

    var image: UIImage? {
        switch self {
        case .atm:
            return UIImage(named: "wallet")
        case .creditDebitCards:
            return UIImage(named: "wallet")
        case .savedCards:
            return UIImage(named: "wallet")
        case .wallet:
            return UIImage(named: "wallet")
        case .newCreditCard:
            return UIImage(named: "wallet")
        case .bankTransfer:
            return UIImage(named: "wallet")
        case .bnpl:
            return UIImage(named: "wallet")
        case .netBanking:
            return UIImage(named: "wallet")
        case .QRCode:
            return UIImage(named: "wallet")
        default:
            return UIImage(named: "wallet")
        }
    }
}

struct PaymentMethodDataSource {
    var type: PaymentMethodType = .atm
    var paymentMethods: [PaymentMethodObject] = []
    var cardPayments: [SavedCard] = []
    var isExpanded: Bool = false
    var isSelected: Bool = false
}
