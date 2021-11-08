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
    
    @IBOutlet var languagePlaceholderView: UIView! {
        didSet {
            languagePlaceholderView.layer.cornerRadius = 8
            languagePlaceholderView.applyShadow()
        }
    }
    
    @IBOutlet var merchantPlaceholderView: UIView! {
        didSet {
            merchantPlaceholderView.layer.cornerRadius = 8
            merchantPlaceholderView.applyShadow()
        }
    }
    
    @objc func onClickLanguage() {
        let productListVC: ChangeLanguageViewController = ViewControllersFactory.viewController()
        self.present(productListVC, animated: true, completion: nil)
    }
    
    @objc func onClickMerchant() {
        let productListVC: ChangeMerchantViewController = ViewControllersFactory.viewController()
        self.present(productListVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "More"
        setupNavBarLargeTitleTheme(color: UIColor(named: "app_theme_color") ?? UIColor.red)
        setupNavBarTitleTheme()
        
        let languageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickLanguage))
        languageViewTapGesture.numberOfTouchesRequired = 1
        languagePlaceholderView.addGestureRecognizer(languageViewTapGesture)
        
        let merchantViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickMerchant))
        languageViewTapGesture.numberOfTouchesRequired = 1
        merchantPlaceholderView.addGestureRecognizer(merchantViewTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
