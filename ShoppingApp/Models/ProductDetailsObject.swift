//
//  ProductDetailsObject.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation
import UIKit

struct ProductDetailsObject {
    var id: String?
    var title: String?
    var description: String?
    var price: Double?
    var currency: String?
    var imageName: String?
    var image: UIImage? {
        return UIImage(named: imageName ?? "")
    }
    var img: UIImage? {
        return UIImage(named: imageName ?? "")
    }
}
