//
//  NoDataTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 26/10/21.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "no_saved_cards".localized
        }
    }
    
    static let cellIdentifier = String(describing: NoDataTableViewCell.self)
}

