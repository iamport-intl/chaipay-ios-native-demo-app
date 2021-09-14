//
//  CardCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var cardTypeImageView: UIImageView!
    @IBOutlet var lastFoursDigits: UILabel!
    @IBOutlet var cardholderName: UILabel!
    @IBOutlet var expiresDateLabel: UILabel!
    @IBOutlet var placeholderView: UIView! {
        didSet {
            placeholderView.layer.cornerRadius = 10
            placeholderView.layer.masksToBounds = true
        }
    }

    static let cellIdentifier = String(describing: CardCollectionViewCell.self)
}

extension CardCollectionViewCell {
    func layout(basedOn cardData: CardData) {
        lastFoursDigits.text = cardData.lastFourDigits
        cardholderName.text = cardData.customerName
        expiresDateLabel.text = cardData.expiryDate
        placeholderView.backgroundColor = cardData.cardType?.color
        cardTypeImageView.image = cardData.cardType?.image
        cardTypeImageView.backgroundColor = .clear
    }
}
