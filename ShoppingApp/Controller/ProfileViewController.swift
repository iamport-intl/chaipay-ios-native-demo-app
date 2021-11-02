//
//  ProfileViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 27/10/21.
//

import UIKit
import PhoneNumberKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var mobileNumberPlaceholderView: UIView! {
        didSet {
            mobileNumberPlaceholderView.layer.cornerRadius = 8
            mobileNumberPlaceholderView.applyShadow()
        }
    }
    @IBOutlet var addressPlaceholderView: UIView! {
        didSet {
            addressPlaceholderView.layer.cornerRadius = 8
            addressPlaceholderView.applyShadow()
        }
    }
    @IBOutlet var ordersPlaceholderView: UIView! {
        didSet {
            ordersPlaceholderView.layer.cornerRadius = 8
            ordersPlaceholderView.applyShadow()
        }
    }
    @IBOutlet var wishlistPlaceholderView: UIView! {
        didSet {
            wishlistPlaceholderView.layer.cornerRadius = 8
            wishlistPlaceholderView.applyShadow()
        }
    }
    @IBOutlet var mobileNumberInputPlaceholderView: UIView! {
        didSet {
            mobileNumberInputPlaceholderView.layer.cornerRadius = 8
            mobileNumberInputPlaceholderView.applyShadow()
        }
    }
    
    @IBOutlet var mobileNumberLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = 40
            profileImageView.layer.borderWidth = 0.5
            profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet var mobileNumberInputTitleLabel: UILabel!
    @IBOutlet weak var mobileTextField: PhoneNumberTextField! {
        didSet {
            mobileTextField.withExamplePlaceholder = true
            mobileTextField.withFlag = true
        }
    }
    @IBOutlet var saveButton: UIButton!
    
    var formattedMobileNumber: String? {
        return (mobileTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarLargeTitleTheme(title: "Profile", color: UIColor(named: "app_theme_color") ?? UIColor.red)
        setupNavBarTitleTheme()
    }
    
    func initialSetup() {
        if let number = UserDefaults.getMobileNumber {
            mobileNumberInputPlaceholderView.isHidden = true
            mobileNumberPlaceholderView.isHidden = false
            mobileNumberLabel.text = number
        } else {
            mobileNumberInputPlaceholderView.isHidden = false
            mobileNumberPlaceholderView.isHidden = true
        }
    }
    
    func setupToolBar() {
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onClickDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [space, done]
        bar.sizeToFit()
        mobileTextField.inputAccessoryView = bar
    }
    
    @IBAction func onClickEditMobileNumber(_ sender: UIButton) {
        mobileTextField.text = UserDefaults.getMobileNumber ?? ""
        mobileNumberInputPlaceholderView.isHidden = false
        mobileNumberPlaceholderView.isHidden = true
    }
    
    @IBAction func onClickSaved(_ sender: UIButton) {
        view.endEditing(true)
        if let mobileNumber = formattedMobileNumber {
            UserDefaults.persistMobileNumber(number: mobileNumber)
            mobileNumberInputPlaceholderView.isHidden = true
            mobileNumberPlaceholderView.isHidden = false
            mobileNumberLabel.text = formattedMobileNumber
        }
    }
    
    @objc
    func onClickDone() {
        view.endEditing(true)
    }
}
