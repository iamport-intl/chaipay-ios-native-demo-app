//
//  SwiftAlertView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 17/09/21.
//

import UIKit

protocol SwiftAlertViewDelegate {
    func checkOutUIv3Clicked()
    func customUIClicked()
}
class SwiftAlertView: UIView {

    var delegate: SwiftAlertViewDelegate?
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.cornerRadius = 10
            shadowView.applyShadow()
        }
    }
    
    @IBOutlet weak var headerTitle: UILabel! {
        didSet {
            headerTitle.text = "alert_option".localized
        }
    }
    @IBOutlet weak var CheckoutUI: UIButton! {
        didSet{
            CheckoutUI.setTitle("web_checkout".localized, for: .normal)
            CheckoutUI.layer.cornerRadius = 5
            CheckoutUI.tintColor = UIColor.white
            CheckoutUI.backgroundColor = UIColor(named: "app_theme_color")
        }
    }
    @IBOutlet weak var CustomUI: UIButton! {
        didSet {
            CustomUI.setTitle("custom_checkout".localized, for: .normal)
            CustomUI.layer.cornerRadius = 5
            CustomUI.tintColor = UIColor.white
            CustomUI.backgroundColor = UIColor(named: "app_theme_color")
        }
    }
    
    @IBAction func onClickCheckOutUI(_ sender: UIButton) {
        delegate?.checkOutUIv3Clicked()
    }
    
    @IBAction func onClickCustomUI(_ sender: UIButton) {
        delegate?.customUIClicked()
    }
}
