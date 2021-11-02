//
//  ProductTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet var placeholderView: UIView!
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var containerView: UIView! {
        didSet{
            containerView.layer.borderWidth = 1
            containerView.layer.cornerRadius = 10
            containerView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
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
        let url = URL(string: shoppingData.imageName ?? "")
        coverImage.sd_setImage(with: url, completed: nil)
       
        let intValue = Int(shoppingData.price ?? 0)
        let formattedPrice = "\(intValue.formatCurrency())"
        let priceAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "custom_color_black") ?? .red] as [NSAttributedString.Key: Any]
        let mutableAttributedString = NSMutableAttributedString(string: formattedPrice, attributes: priceAttributes)

        let customAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "app_theme_color")]
        let inStockAttributedString = NSAttributedString(string: " In stock", attributes: customAttributes)
        mutableAttributedString.append(inStockAttributedString)

        priceLabel.attributedText = mutableAttributedString
    }
}


extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

