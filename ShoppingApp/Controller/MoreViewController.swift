//
//  MoreViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 27/10/21.
//

import UIKit

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
    
    @IBOutlet var currencyPlaceholderView: UIView! {
        didSet {
            currencyPlaceholderView.layer.cornerRadius = 8
            currencyPlaceholderView.applyShadow()
        }
    }
    
    @IBOutlet var merchantPlaceholderView: UIView! {
        didSet {
            merchantPlaceholderView.layer.cornerRadius = 8
            merchantPlaceholderView.applyShadow()
        }
    }
    
    @IBOutlet var themeColorPlaceHolder: UIView! {
        didSet {
            themeColorPlaceHolder.layer.cornerRadius = 8
            themeColorPlaceHolder.applyShadow()
        }
    }
    
    @IBOutlet var preAuthPlaceholderView: UIView! {
        didSet {
            preAuthPlaceholderView.layer.cornerRadius = 8
            preAuthPlaceholderView.applyShadow()
        }
    }
    
    @IBOutlet var merchantCardVaultPlaceHolder: UIView! {
        didSet {
            merchantCardVaultPlaceHolder.layer.cornerRadius = 8
            merchantCardVaultPlaceHolder.applyShadow()
        }
    }
    
    @objc func onClickLanguage() {
        let productListVC: ChangeLanguageViewController = ViewControllersFactory.viewController()
        self.present(productListVC, animated: true, completion: nil)
    }
    
    @objc func onClickCurrency() {
        let productListVC: ChangeCurrencyViewController = ViewControllersFactory.viewController()
        self.present(productListVC, animated: true, completion: nil)
    }
    
    @objc func onClickMerchant() {
        let productListVC: ChangeMerchantViewController = ViewControllersFactory.viewController()
        self.present(productListVC, animated: true, completion: nil)
    }
    
    @objc func onClickThemeColor() {
        let productListVC: ChangeThemeColorViewController = ViewControllersFactory.viewController()
        self.present(productListVC, animated: true, completion: nil)
    }
    
    @objc func onClickPreAuth() {
        let preAuthVC: PreAuthViewController = ViewControllersFactory.viewController()
        self.present(preAuthVC, animated: true, completion: nil)
    }
    
    @objc func onClickMerchantCardVault() {
        let merchantCardVaultVC: MerchantCardVaultViewController = ViewControllersFactory.viewController()
        self.present(merchantCardVaultVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "More"
        setupNavBarLargeTitleTheme(color: UIColor(named: "app_theme_color") ?? UIColor.red)
        setupNavBarTitleTheme()
        
        let languageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickLanguage))
        languageViewTapGesture.numberOfTouchesRequired = 1
        languagePlaceholderView.addGestureRecognizer(languageViewTapGesture)
        
        let currencyViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickCurrency))
        currencyViewTapGesture.numberOfTouchesRequired = 1
        currencyPlaceholderView.addGestureRecognizer(currencyViewTapGesture)
        
        let merchantViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickMerchant))
        languageViewTapGesture.numberOfTouchesRequired = 1
        merchantPlaceholderView.addGestureRecognizer(merchantViewTapGesture)
        
        let themeColorGesture = UITapGestureRecognizer(target: self, action: #selector(onClickThemeColor))
        themeColorGesture.numberOfTouchesRequired = 1
        themeColorPlaceHolder.addGestureRecognizer(themeColorGesture)
        
        let preAuthTapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickPreAuth))
        preAuthTapGesture.numberOfTouchesRequired = 1
        preAuthPlaceholderView.addGestureRecognizer(preAuthTapGesture)
        
        let merchantCardVaultGesture = UITapGestureRecognizer(target: self, action: #selector(onClickMerchantCardVault))
        merchantCardVaultGesture.numberOfTouchesRequired = 1
        merchantCardVaultPlaceHolder.addGestureRecognizer(merchantCardVaultGesture)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
