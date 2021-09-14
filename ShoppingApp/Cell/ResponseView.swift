//
//  ResponseView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 09/09/21.
//

import UIKit

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
    
    var isSuccess: Bool = false
    @IBAction func onClickButton(_ sender: UIButton) {
        delegate?.goBack(fromSuccess: isSuccess)
    }

    func setLayout(isSuccess: Bool, amount: String) {
       
            responseTypeImage.image = UIImage(named: isSuccess ? "icon_success" : "icon_failed")
            headerTitle.text = isSuccess ? "Payment Successful" : "Payment failed"
            descriptionTitle.text =  isSuccess ? "Thank you for shopping with us." : "Please try again"
        self.isSuccess = isSuccess
        buttonTitle.setTitle(isSuccess ? "Continue" : "Go Back", for: .normal)
        buttonTitle.backgroundColor =  UIColor(named: isSuccess ? "success_green_color" : "app_theme_color") 
    }
}
