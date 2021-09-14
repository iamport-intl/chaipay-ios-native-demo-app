//
//  CardsDataManager.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation

class CardsDataManager {
    static func getCardsData() -> [CardData] {
        let card1 = CardData(cardType: .visa, lastFourDigits: "1114", customerName: "Sireesha Neelapu", expiryDate: "12/27")

        let card2 = CardData(cardType: .master, lastFourDigits: "1225", customerName: "Salma Khatun", expiryDate: "12/30")

        let card3 = CardData(cardType: .rupay, lastFourDigits: "2005", customerName: "Appala Naidu", expiryDate: "12/23")

        let card4 = CardData(cardType: .visa, lastFourDigits: "1234", customerName: "SpiderMan", expiryDate: "12/25")

        return [card1, card2, card3, card4]
    }
}
