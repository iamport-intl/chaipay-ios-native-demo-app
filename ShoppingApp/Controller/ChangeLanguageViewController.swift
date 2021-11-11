//
//  ChangeLanguageViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 2/11/21.
//

import UIKit

enum Language: String {
    case english
    case thailand
    case vietnam
    
    var code: String {
        switch self {
        case .english:
            return "en"
        case .thailand:
            return "th"
        case .vietnam:
            return "vi"
        }
    }
    
    var title: String {
        switch self {
        case .english:
            return "English"
        case .thailand:
            return "Thailand"
        case .vietnam:
            return "Vietnam"
        }
    }
}

class ChangeLanguageViewController: UIViewController {

    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = NSLocalizedString("Change_Language_Sub_Title", comment: "")
        }
    }
    @IBOutlet weak var germanLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel! 
    @IBOutlet weak var germanImageView: UIImageView!
    @IBOutlet weak var englishImageView: UIImageView!
    @IBOutlet weak var thaiPlaceholderView: UIView!
    @IBOutlet weak var englishPlaceholderView: UIView!
    @IBOutlet weak var vietnamesePlaceholderView: UIView!
   
    @IBOutlet weak var thaiCheckboxView: UIView! {
        didSet {
            thaiCheckboxView.layer.cornerRadius = 15/2
        }
    }
    @IBOutlet weak var englishCheckboxView: UIView! {
        didSet {
            englishCheckboxView.layer.cornerRadius = 15/2
        }
    }
    @IBOutlet weak var vietnameseCheckboxView: UIView! {
        didSet {
            vietnameseCheckboxView.layer.cornerRadius = 15/2
        }
    }
    
    @IBOutlet weak var thaiOuterView: UIView! {
        didSet {
            thaiOuterView.layer.cornerRadius = 25/2
            thaiOuterView.layer.borderWidth = 1
            thaiOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var englishOuterView: UIView! {
        didSet {
            englishOuterView.layer.cornerRadius = 25/2
            englishOuterView.layer.borderWidth = 1
            englishOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var vietnameseOuterView: UIView! {
        didSet {
            vietnameseOuterView.layer.cornerRadius = 25/2
            vietnameseOuterView.layer.borderWidth = 1
            vietnameseOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    
    lazy var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named: "icon_cross"), style: .plain, target: self, action: #selector(onClickCancelButton))
        return barButton
    }()
    
    var successCallback: ((String) -> Void)?
    var selectedLanguage: Language {
        return UserDefaults.getLanguage
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
        self.subTitleLabel.text = "Change_Language_Msg".localized
        germanLabel.text = "Thai"
        englishLabel.text = "English"
        self.navigationItem.rightBarButtonItem = cancelBarButton
        
        switch selectedLanguage {
        case .english:
            setupThemeEnglish()
        case .thailand:
            setupThemeThai()
        case .vietnam:
            setupThemeVietnam()
        }
    }
    
    @objc
    func onClickCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTapGestures() {
        let thaiTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectThai))
        thaiTapGesture.numberOfTouchesRequired = 1
        thaiPlaceholderView.addGestureRecognizer(thaiTapGesture)
        
        let englishTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectEnglish))
        englishTapGesture.numberOfTouchesRequired = 1
        englishPlaceholderView.addGestureRecognizer(englishTapGesture)
        
        let vietanmeseTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectVietnamese))
        vietanmeseTapGesture.numberOfTouchesRequired = 1
        vietnamesePlaceholderView.addGestureRecognizer(vietanmeseTapGesture)
    }
    
    func setupThemeThai() {
        thaiCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
        englishCheckboxView.backgroundColor = UIColor.clear
        vietnameseCheckboxView.backgroundColor = UIColor.clear
    }
    
    @objc
    func onSelectThai() {
        setupThemeThai()
        self.changeLanguage(.thailand)
    }
    
    func setupThemeEnglish() {
        thaiCheckboxView.backgroundColor = UIColor.clear
        englishCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
        vietnameseCheckboxView.backgroundColor = UIColor.clear
    }
    
    @objc
    func onSelectEnglish() {
        setupThemeEnglish()
        self.changeLanguage(.english)
    }
    
    func setupThemeVietnam() {
        thaiCheckboxView.backgroundColor = UIColor.clear
        englishCheckboxView.backgroundColor = UIColor.clear
        vietnameseCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
    }
    
    @objc
    func onSelectVietnamese() {
        setupThemeVietnam()
        self.changeLanguage(.vietnam)
    }
    
    
    func showChangeLanguageAlert(okayCallBack: (() -> Void)?) {
        let alertVC = UIAlertController(title: NSLocalizedString("Restart_Title", comment: ""), message: NSLocalizedString("Restart_Msg", comment: ""), preferredStyle: .alert)
        let okayAction = UIAlertAction(title: NSLocalizedString("Close_Now_Button", comment: ""), style: UIAlertAction.Style.destructive) { _ in
            okayCallBack?()
        }
        let noAction = UIAlertAction(title: NSLocalizedString("Not_Now_Button", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)

        alertVC.addAction(noAction)
        alertVC.addAction(okayAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    func changeLanguage(_ language: Language) {
        //Set default language as app language
        UserDefaults.persistAppLanguageCode(language: language)
        UserDefaults.persistAppLanguage(langCode: language.code)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                exit(EXIT_SUCCESS)
            })
        }
    }
}
