//
//  ProductHeaderCollectionReusableView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 29/07/21.
//

import UIKit

class ProductHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet var infoLabel: UILabel!

    static let cellIdentifier = String(describing: ProductHeaderCollectionReusableView.self)
}
