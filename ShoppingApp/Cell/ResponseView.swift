//
//  ResponseView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 09/09/21.
//

import UIKit
import ChaiPayPaymentSDK

protocol ResponseViewDelegate {
    func goBack(fromSuccess: Bool)
}
class ResponseView: UIView {

    var delegate: ResponseViewDelegate?
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.applyShadow()
        }
    }
    @IBOutlet weak var responseTypeImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var buttonTitle: UIButton!
    @IBOutlet weak var stackPlaceholderView: UIView!
    @IBOutlet weak var merchantOrderRef: UILabel!
    @IBOutlet weak var channelOrderRef: UILabel!
    @IBOutlet weak var Status: UILabel!
    
    var isSuccess: Bool = false
    @IBAction func onClickButton(_ sender: UIButton) {
        delegate?.goBack(fromSuccess: isSuccess)
    }

    func setLayout(isSuccess: Bool, amount: String, _ response: WebViewResponse?) {
        
        responseTypeImage.image = UIImage(named: isSuccess ? "icon_success" : "icon_failed")
        headerTitle.text = isSuccess ? "Payment Successful" : "Payment failed"
        descriptionTitle.text =  isSuccess ? "Thank you for shopping with us." : "Please try again"
        self.isSuccess = isSuccess
        self.merchantOrderRef.text = response?.merchantOrderRef
        self.channelOrderRef.text = response?.channelOrderRef
        self.Status.text = response?.status
        buttonTitle.setTitle(isSuccess ? "Continue" : "Go Back", for: .normal)
        buttonTitle.backgroundColor =  UIColor(named: isSuccess ? "success_green_color" : "app_theme_color")
        
    }
    
    func setupStackView() {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: stackPlaceholderView.bounds.width, height: 50))
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        
        let nameValueLabel = UILabel()
        nameValueLabel.text = "S"
        
        let priceStack = UIStackView(arrangedSubviews: [nameLabel, nameValueLabel])
        priceStack.axis = .horizontal
        priceStack.distribution = .fillProportionally
        
        stackView.addArrangedSubview(priceStack)
        stackPlaceholderView.backgroundColor = UIColor.red
        stackPlaceholderView.addSubview(stackView)
    }
}
