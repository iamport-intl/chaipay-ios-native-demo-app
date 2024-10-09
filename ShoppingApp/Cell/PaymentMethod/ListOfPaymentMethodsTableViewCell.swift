//
//  ListOfPaymentMethodsTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 07/09/21.
//

import UIKit
import PortoneSDK

class ListOfPaymentMethodsTableViewCell: UITableViewCell {

    @IBOutlet var selectionImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var paymentMethodImageView: UIImageView!

    @IBOutlet var placeholderView: UIView!
    
    static let cellIdentifier = String(describing: ListOfPaymentMethodsTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if #available(iOS 13.0, *) {
            if highlighted {
                placeholderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            } else {
                placeholderView.backgroundColor = .white
            }
        } else {
            super.setHighlighted(highlighted, animated: animated)
        }
        self.backgroundColor = .white
    }
}

extension ListOfPaymentMethodsTableViewCell {
    func layout(basedOn methodObject: PaymentMethodObject, isSelected: Bool = false) {
       
        let url = URL(string: methodObject.logo)
        
        paymentMethodImageView.sd_setImage(with: url, placeholderImage: nil)
        titleLabel.text = methodObject.displayName
        selectionImageView.image =  UIImage(named: isSelected ? "icon_selected" : "icon_deSelected") 
    }
    func layout(basedOn methodObject: SavedCard, isSelected: Bool = false) {
        var imageString = ""
        switch methodObject.type {
        case "visa":
            imageString = "visa"
        case "mastercard":
            imageString = "masterCard"
        case "jcb":
            imageString = "jcb"
        default:
            imageString = ["masterCard", "visa", "jcb"].randomElement() ?? ""
        }
        
        paymentMethodImageView.image = UIImage(named: imageString)
        titleLabel.text = methodObject.partialCardNumber
        descriptionLabel.text = methodObject.expiryMonth + "/" + methodObject.expiryYear
        descriptionLabel.textColor = UIColor.darkGray
        selectionImageView.image =  UIImage(named: isSelected ? "icon_selected" : "icon_deSelected")
    }
}

