//
//  PaymentShippingAddressTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 25/10/21.
//

import UIKit

class PaymentShippingAddressTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var placeholderView: UIView! {
        didSet {
            placeholderView.applyShadow()
            placeholderView.layer.cornerRadius = 10
        }
    }
    
    static let cellIdentifier = String(describing: PaymentShippingAddressTableViewCell.self)
}

extension PaymentShippingAddressTableViewCell {
    func layout(basedOn title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
