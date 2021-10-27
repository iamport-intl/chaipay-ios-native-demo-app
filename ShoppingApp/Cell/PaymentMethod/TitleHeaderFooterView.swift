//
//  TitleHeaderFooterView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 07/09/21.
//

import UIKit

class TitleHeaderFooterView: UITableViewHeaderFooterView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleView: UIView!
    static let cellIdentifier = String(describing: TitleHeaderFooterView.self)
   
    func applyShadowView() {
        titleView.applyShadow()
    }
}

extension TitleHeaderFooterView {
    func layout(basedOn title: String, applyShadow: Bool = false) {
        titleLabel.text = title
        if(applyShadow) {
            applyShadowView()
        }
    }
}
