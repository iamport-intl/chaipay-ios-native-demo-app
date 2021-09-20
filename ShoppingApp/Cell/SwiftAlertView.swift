//
//  SwiftAlertView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 17/09/21.
//

import UIKit

protocol SwiftAlertViewDelegate {
    func checkOutUIClicked()
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
            headerTitle.text = "Please choose one of the below UI method to proceed further"
        }
    }
    @IBOutlet weak var CheckoutUI: UIButton! {
        didSet{
            CheckoutUI.setTitle("SDK Checkout UI", for: .normal)
            CheckoutUI.layer.cornerRadius = 5
            CheckoutUI.tintColor = UIColor.white
            CheckoutUI.backgroundColor = UIColor(named: "app_theme_color")
        }
    }
    @IBOutlet weak var CustomUI: UIButton! {
        didSet {
            CustomUI.setTitle("Custom UI", for: .normal)
            CustomUI.layer.cornerRadius = 5
            CustomUI.tintColor = UIColor.white
            CustomUI.backgroundColor = UIColor(named: "app_theme_color")
        }
    }
    
    @IBAction func onClickCheckOutUI(_ sender: UIButton) {
        delegate?.checkOutUIClicked()
    }
    
    @IBAction func onClickCustomUI(_ sender: UIButton) {
        delegate?.customUIClicked()
    }
}
