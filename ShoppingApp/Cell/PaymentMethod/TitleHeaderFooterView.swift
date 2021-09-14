//
//  TitleHeaderFooterView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 07/09/21.
//

import UIKit

class TitleHeaderFooterView: UITableViewHeaderFooterView {
    @IBOutlet var titleLabel: UILabel!
    static let cellIdentifier = String(describing: TitleHeaderFooterView.self)
}

extension TitleHeaderFooterView {
    func layout(basedOn title: String) {
        titleLabel.text = title
    }
}
