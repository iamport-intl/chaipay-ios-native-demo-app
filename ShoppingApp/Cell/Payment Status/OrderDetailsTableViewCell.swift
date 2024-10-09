//
//  OrderDetailsTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 25/10/21.
//

import UIKit
import PortoneSDK

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDetailsTitleLabel: UILabel!
    @IBOutlet weak var merchantOrderRefValueLabel: UILabel!
    @IBOutlet weak var channelOrderRefValueLabel: UILabel!
    @IBOutlet weak var orderAmountValueLabel: UILabel!
    @IBOutlet weak var deliveryAmountValueLabel: UILabel!
    @IBOutlet weak var amountPaidValueLabel: UILabel!
    @IBOutlet weak var placeholderView: UIView! {
        didSet {
            placeholderView.applyShadow()
            placeholderView.layer.cornerRadius = 10
        }
    }
    
    static let cellIdentifier = String(describing: OrderDetailsTableViewCell.self)
    
}
extension OrderDetailsTableViewCell {
    func layout(basedOn response: TransactionResponse?, amount: Int, delivery: Int, message: String?) {
       
        orderAmountValueLabel.text = amount.formatCurrency()
        deliveryAmountValueLabel.text = delivery.formatCurrency()
        amountPaidValueLabel.text = (amount + delivery).formatCurrency()
        
        if let y = response  {
            let issuccess = y.isSuccess ?? false
            orderDetailsTitleLabel.text =  issuccess ? "Payment Successful" : "Payment failed \n \(message ?? "")"
        }
    }
}
