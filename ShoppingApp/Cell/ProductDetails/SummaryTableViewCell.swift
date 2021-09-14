//
//  SummaryTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    @IBOutlet var orderTitleLabel: UILabel!
    @IBOutlet var orderValueLabel: UILabel!

    @IBOutlet var deliveryTitleLabel: UILabel!
    @IBOutlet var deliveryValueLabel: UILabel!

    @IBOutlet var summaryTitleLabel: UILabel!
    @IBOutlet var summaryValueLabel: UILabel!

    static let cellIdentifier = String(describing: SummaryTableViewCell.self)
}

extension SummaryTableViewCell {
    func layout(basedOn summaryObject: SummaryObject) {
        orderTitleLabel.text = summaryObject.orderTitle
        orderValueLabel.text = summaryObject.orderValue

        deliveryTitleLabel.text = summaryObject.deliveryTitle
        deliveryValueLabel.text = summaryObject.deliveryValue

        summaryTitleLabel.text = summaryObject.summaryTitle
        summaryValueLabel.text = summaryObject.summaryValue
    }
}
