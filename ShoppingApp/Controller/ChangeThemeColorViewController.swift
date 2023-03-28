//
//  ChangeThemeColorViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 03/08/22.
//

import Foundation
import UIKit

enum ThemeColor: String {
    case red
    case green
    case blue
    
    var code: String {
        switch self {
        case .red:
            return "#FF0000"
        case .green:
            return "#006400"
        case .blue:
            return "#000000"
        }
    }
    
    var title: String {
        switch self {
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        }
    }
}

enum Layout: String {
    case zero
    case one
    case two
    
    var code: Int {
        switch self {
        case .zero:
            return 0
        case .one:
            return 1
        case .two:
            return 2
        }
    }
    
    var title: String {
        switch self {
        case .one:
            return "one"
        case .two:
            return "two"
        case .zero:
            return "Zero"
        }
    }
}

class ChangeThemeColorViewController: UIViewController {

    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = "Change Theme colour"
        }
    }
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    @IBOutlet weak var germanImageView: UIImageView!
    @IBOutlet weak var englishImageView: UIImageView!
    @IBOutlet weak var redPlaceholderView: UIView!
    @IBOutlet weak var greenPlaceholderView: UIView!
    @IBOutlet weak var bluePlaceholderView: UIView!
   
    @IBOutlet weak var redCheckboxView: UIView! {
        didSet {
            redCheckboxView.layer.cornerRadius = 15/2
        }
    }
    @IBOutlet weak var greenCheckboxView: UIView! {
        didSet {
            greenCheckboxView.layer.cornerRadius = 15/2
        }
    }
    @IBOutlet weak var blueCheckboxView: UIView! {
        didSet {
            blueCheckboxView.layer.cornerRadius = 15/2
        }
    }
    
    @IBOutlet weak var redOuterView: UIView! {
        didSet {
            redOuterView.layer.cornerRadius = 25/2
            redOuterView.layer.borderWidth = 1
            redOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var greenOuterView: UIView! {
        didSet {
            greenOuterView.layer.cornerRadius = 25/2
            greenOuterView.layer.borderWidth = 1
            greenOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var blueOuterView: UIView! {
        didSet {
            blueOuterView.layer.cornerRadius = 25/2
            blueOuterView.layer.borderWidth = 1
            blueOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    
    lazy var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named: "icon_cross"), style: .plain, target: self, action: #selector(onClickCancelButton))
        return barButton
    }()
    
    var successCallback: ((String) -> Void)?
    var selectedColor: ThemeColor {
        return UserDefaults.getThemeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThemedNavbar()
        setupNavBarTitleTheme()
        setupInitialData()
        setupTapGestures()
    }
    
    func setupInitialData() {
        self.navigationItem.title = NSLocalizedString("Change_Language_Title", comment: "")
        self.subTitleLabel.text = "Please change the theme color"
        redLabel.text = "Red"
        greenLabel.text = "Green"
        blueLabel.text = "Blue"
        
        self.navigationItem.rightBarButtonItem = cancelBarButton
        
        switch selectedColor {
        case .red:
            setupThemeRed()
        case .green:
            setupThemeGreen()
        case .blue:
            setupThemeBlue()
        }
    }
    
    @objc
    func onClickCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTapGestures() {
        let redTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectRed))
        redTapGesture.numberOfTouchesRequired = 1
        redPlaceholderView.addGestureRecognizer(redTapGesture)
        
        let greenTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectGreen))
        greenTapGesture.numberOfTouchesRequired = 1
        greenPlaceholderView.addGestureRecognizer(greenTapGesture)
        
        let blueTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectBlue))
        blueTapGesture.numberOfTouchesRequired = 1
        bluePlaceholderView.addGestureRecognizer(blueTapGesture)
    }
    
    func setupThemeGreen() {
        greenCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
        redCheckboxView.backgroundColor = UIColor.clear
        blueCheckboxView.backgroundColor = UIColor.clear
    }
    
    @objc
    func onSelectGreen() {
        setupThemeGreen()
        self.changeLanguage(.green)
    }
    
    func setupThemeRed() {
        greenCheckboxView.backgroundColor = UIColor.clear
        redCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
        blueCheckboxView.backgroundColor = UIColor.clear
    }
    
    @objc
    func onSelectRed() {
        setupThemeRed()
        self.changeLanguage(.red)
    }
    
    func setupThemeBlue() {
        redCheckboxView.backgroundColor = UIColor.clear
        greenCheckboxView.backgroundColor = UIColor.clear
        blueCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
    }
    
    @objc
    func onSelectBlue() {
        setupThemeBlue()
        self.changeLanguage(.blue)
    }


    func changeLanguage(_ color: ThemeColor) {
        //Set default language as app language
        UserDefaults.persistAppThemeColorCode(color: color)
        switch color {
        case .red:
            UserDefaults.persistLayoutCode(layout: .zero)
        case .green:
            UserDefaults.persistLayoutCode(layout: .one)
        case .blue:
            UserDefaults.persistLayoutCode(layout: .two)
        }
    }
}
