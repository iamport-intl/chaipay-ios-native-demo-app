//
//  SelectEnvironmentTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 05/11/21.
//

import UIKit

class SelectEnvironmentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkboxView: UIView! {
        didSet {
            checkboxView.layer.cornerRadius = 15/2
        }
    }
    
    @IBOutlet weak var checkboxOuterView: UIView! {
        didSet {
            checkboxOuterView.layer.cornerRadius = 25/2
            checkboxOuterView.layer.borderWidth = 1
            checkboxOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    static let cellIdentifier = String(describing: SelectEnvironmentTableViewCell.self)
}

extension SelectEnvironmentTableViewCell {
    func layout(basedOn environmentObject: EnvironmentObject, isSelected: Bool) {
        titleLabel.text = environmentObject.environmentTitle
        checkboxView.backgroundColor = isSelected ? UIColor(named: "app_theme_color") : UIColor.clear
    }
}
