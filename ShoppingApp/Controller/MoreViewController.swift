//
//  MoreViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 27/10/21.
//

import UIKit
import PhoneNumberKit

class MoreViewController: UIViewController {
    
    @IBOutlet var FAQPlaceholderView: UIView! {
        didSet {
            FAQPlaceholderView.layer.cornerRadius = 8
            FAQPlaceholderView.applyShadow()
        }
    }
    @IBOutlet var aboutUsPlaceholderView: UIView! {
        didSet {
            aboutUsPlaceholderView.layer.cornerRadius = 8
            aboutUsPlaceholderView.applyShadow()
        }
    }
    @IBOutlet var termsPlaceholderView: UIView! {
        didSet {
            termsPlaceholderView.layer.cornerRadius = 8
            termsPlaceholderView.applyShadow()
        }
    }
    @IBOutlet var privacyPolicyPlaceholderView: UIView! {
        didSet {
            privacyPolicyPlaceholderView.layer.cornerRadius = 8
            privacyPolicyPlaceholderView.applyShadow()
        }
    }
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarLargeTitleTheme(title: "More", color: UIColor(named: "app_theme_color") ?? UIColor.red)
        setupNavBarTitleTheme()
    }
}
