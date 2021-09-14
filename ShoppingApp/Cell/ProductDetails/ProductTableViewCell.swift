//
//  ProductTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet var placeholderView: UIView!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    static let cellIdentifier = String(describing: ProductTableViewCell.self)

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeholderView.layer.cornerRadius = 10
        placeholderView.layer.masksToBounds = true
        
        coverImage.layer.cornerRadius = 10
        coverImage.layer.masksToBounds = true
    }
}

extension ProductTableViewCell {
    func layout(basedOn shoppingData: ProductDetailsObject) {
        titleLabel.text = shoppingData.title
        titleLabel.textColor = UIColor(named: "custom_color_black")
        descriptionLabel.text = shoppingData.description
        descriptionLabel.textColor = UIColor(named: "custom_color_gray")
        coverImage.image = UIImage(named: shoppingData.imageName ?? "")

        let intValue = Int(shoppingData.price ?? 0)
        let formattedPrice = (shoppingData.currency ?? "") + "\(intValue)"
        let priceAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "custom_color_black") ?? .red] as [NSAttributedString.Key: Any]
        let mutableAttributedString = NSMutableAttributedString(string: formattedPrice, attributes: priceAttributes)

        let customAttributes = [NSAttributedString.Key.foregroundColor: UIColor.cyan]
        let inStockAttributedString = NSAttributedString(string: " In stock", attributes: customAttributes)
        mutableAttributedString.append(inStockAttributedString)

        priceLabel.attributedText = mutableAttributedString
    }
}
