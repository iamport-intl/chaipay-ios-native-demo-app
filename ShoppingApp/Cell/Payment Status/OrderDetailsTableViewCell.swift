//
//  OrderDetailsTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 25/10/21.
//

import UIKit
import ChaiPayPaymentSDK

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
    func layout(basedOn response: WebViewResponse?, amount: Int, delivery: Int) {
        print("WebviewResponse", response)
        orderAmountValueLabel.text = amount.formatCurrency()
        deliveryAmountValueLabel.text = delivery.formatCurrency()
        amountPaidValueLabel.text = (amount + delivery).formatCurrency()
        
        if let y = response  {
            let issuccess = y.isSuccess == "true"
            orderDetailsTitleLabel.text =  issuccess ? "Payment Successful" : "Payment failed"
        }
        
//        responseTypeImage.image = UIImage(named: isSuccess ? "icon_success" : "icon_failed")
//        descriptionTitle.text =  isSuccess ? "Thank you for shopping with us." : "Please try again"
//        self.isSuccess = isSuccess
//        self.merchantOrderRef.text = response?.merchantOrderRef ?? "MERCHANT12345678"
//        self.channelOrderRef.text = response?.channelOrderRef ?? "5000"
//        self.Status.text = response?.status ?? "18000"
    }
}
