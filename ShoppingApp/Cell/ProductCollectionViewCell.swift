//
//  ProductCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet var placeholderView: UIView! {
        didSet {
            placeholderView.applyShadow()
            placeholderView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet var containerView: UIView! {
        didSet {
            containerView.applyShadow()
            containerView.layer.cornerRadius = 8
        }
    }
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    static let cellIdentifier = String(describing: ProductCollectionViewCell.self)

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 10

        placeholderView.layer.cornerRadius = 10
        placeholderView.layer.masksToBounds = true

        coverImage.layer.cornerRadius = 10
        coverImage.layer.masksToBounds = true
    }
}

extension ProductCollectionViewCell {
    func layout(basedOn shoppingData: ProductDetailsObject, isSelected: Bool = false) {
        titleLabel.text = shoppingData.title
        titleLabel.textColor = UIColor(named: "custom_color_black")
        descriptionLabel.text = shoppingData.description
        descriptionLabel.textColor = UIColor(named: "custom_color_gray")
        let intValue = Int(shoppingData.price ?? 0)
        priceLabel.text = "\(intValue.formatCurrency())"
        priceLabel.textColor = UIColor(named: "app_theme_color")
        let url =  URL(string: shoppingData.imageName ?? "")
        coverImage.sd_setImage(with: url, completed: nil)
        coverImage.contentMode = .scaleAspectFit
        if isSelected {
            self.contentView.layer.borderColor = UIColor(named: "app_theme_color")?.cgColor
            self.contentView.layer.borderWidth = 1
        } else {
            self.contentView.layer.borderColor = UIColor.white.cgColor
            self.contentView.layer.borderWidth = 0
        }
    }
}
