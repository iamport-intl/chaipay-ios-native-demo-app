//
//  CardData.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation
import UIKit

enum CardType {
    case visa
    case master
    case rupay

    var color: UIColor {
        switch self {
        case .master:
            return UIColor(named: "master_card_color") ?? .red
        case .rupay:
            return UIColor(named: "rupay_card_color") ?? .green
        case .visa:
            return UIColor(named: "visa_card_color") ?? .yellow
        }
    }
    
    var image: UIImage? {
        switch self {
        case .master:
            return UIImage(named: "masterCard")
        case .rupay:
            return UIImage(named: "ruPay")
        case .visa:
            return UIImage(named: "visa")
        }
    }
}

struct CardData {
    var cardType: CardType?
    var lastFourDigits: String?
    var customerName: String?
    var expiryDate: String?
}
