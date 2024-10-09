//
//  ChangeCurrencyViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 29/11/22.
//

import Foundation
import UIKit
import PortoneSDK

struct CurrencyObj {
    var name: String? = "Vietnamese"
    var code:  String? = "vn-VN"
    var languageCode:  String? = "vn"
    var currency:  String? = "VND"
}
class CurrencyManager {
static let Currencies = [
    CurrencyObj(name: "Thai",
                code: "th-TH",
                languageCode: "th",
                currency: "THB"),
    CurrencyObj(name: "Vietnamese",
                code: "vn-VN",
                languageCode: "vn",
                currency: "VND"),
    CurrencyObj(name: "Singapore",
                code: "en-SG    ",
                languageCode: "en",
                currency: "SGD"),
    CurrencyObj(name: "Indonesia",
                code: "id-ID",
                languageCode: "id",
                currency: "IDR"),
    CurrencyObj(name: "Phillipines",
                code: "id-ID",
                languageCode: "ph",
                currency: "PHP"),
    
]
}
extension CurrencyObj {
    var toJSONDict : [String:String?] {
        return ["name":name, "code":code, "languageCode": languageCode, "currency": currency]
    }
}

enum Currency: String {
    case english
    case thailand
    case vietnam
    case singapore
    case indonesia
    case philippines
    
    var code: String {
        switch self {
        case .english:
            return "TWD"
        case .thailand:
            return "THB"
        case .vietnam:
            return "VND"
        case .singapore:
            return "SGD"
        case .indonesia:
            return "IDR"
        case .philippines:
            return "PHP"
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
        case .indonesia:
            return "Indonesia"
        case .singapore:
            return "Singapore"
        case .philippines:
            return "Philipines"
            
        }
    }
}

class ChangeCurrencyViewController: UIViewController {

    var checkout: Checkout? {
        return AppDelegate.shared.checkout
    }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = "Change Currency"
        }
    }
    @IBOutlet weak var germanLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!

    @IBOutlet weak var thaiPlaceholderView: UIView!
    @IBOutlet weak var englishPlaceholderView: UIView!
    @IBOutlet weak var vietnamesePlaceholderView: UIView!
    @IBOutlet weak var singaporePlaceholderView: UIView!
    @IBOutlet weak var IndonesiaPlaceholderView: UIView!
   
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
    
    @IBOutlet weak var singaporeCheckboxView: UIView! {
        didSet {
            singaporeCheckboxView.layer.cornerRadius = 15/2
        }
    }
    @IBOutlet weak var indonesiaCheckboxView: UIView! {
        didSet {
            indonesiaCheckboxView.layer.cornerRadius = 15/2
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
    
    @IBOutlet weak var singaporeOuterView: UIView! {
        didSet {
            singaporeOuterView.layer.cornerRadius = 25/2
            singaporeOuterView.layer.borderWidth = 1
            singaporeOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var indonesiaOuterView: UIView! {
        didSet {
            indonesiaOuterView.layer.cornerRadius = 25/2
            indonesiaOuterView.layer.borderWidth = 1
            indonesiaOuterView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    lazy var cancelBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: UIImage(named: "icon_cross"), style: .plain, target: self, action: #selector(onClickCancelButton))
        return barButton
    }()
    
    var successCallback: ((String) -> Void)?
    var selectedCurrency: Currency {
        return UserDefaults.getCurrency
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
        
        switch selectedCurrency {
        case .english:
            setupThemeEnglish()
        case .thailand:
            setupThemeThai()
        case .vietnam:
            setupThemeVietnam()
        case .singapore:
            setupThemeSingapore()
        case .indonesia:
            setupThemeIndonesia()
        case .philippines:
            setupThemeIndonesia()
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
        
        let singaporeTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectSingapore))
        singaporeTapGesture.numberOfTouchesRequired = 1
        singaporePlaceholderView.addGestureRecognizer(singaporeTapGesture)
        
        let indonesiaTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectIndonesia))
        indonesiaTapGesture.numberOfTouchesRequired = 1
        IndonesiaPlaceholderView.addGestureRecognizer(indonesiaTapGesture)
    }
    
    
    @objc
    func onSelectThai() {
        setupThemeThai()
        self.changeLanguage(.thailand)
    }
    
    @objc
    func onSelectSingapore() {
        setupThemeSingapore()
        self.changeLanguage(.singapore)
    }
    
    @objc
    func onSelectIndonesia() {
        setupThemeIndonesia()
        self.changeLanguage(.indonesia)
    }
    
    @objc
    func onSelectEnglish() {
        setupThemeEnglish()
        self.changeLanguage(.english)
    }
    
    @objc
    func onSelectVietnamese() {
        setupThemeVietnam()
        self.changeLanguage(.vietnam)
    }
    
    
    
    func setupThemeThai() {
        thaiCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
        englishCheckboxView.backgroundColor = UIColor.clear
        vietnameseCheckboxView.backgroundColor = UIColor.clear
        singaporeCheckboxView.backgroundColor = .clear
        indonesiaCheckboxView.backgroundColor = .clear
    }
    
    
    func setupThemeEnglish() {
        thaiCheckboxView.backgroundColor = UIColor.clear
        englishCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
        vietnameseCheckboxView.backgroundColor = UIColor.clear
        singaporeCheckboxView.backgroundColor = .clear
        indonesiaCheckboxView.backgroundColor = .clear
    }
    
   
    
    func setupThemeVietnam() {
        thaiCheckboxView.backgroundColor = UIColor.clear
        englishCheckboxView.backgroundColor = UIColor.clear
        singaporeCheckboxView.backgroundColor = .clear
        indonesiaCheckboxView.backgroundColor = .clear
        vietnameseCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
    }
    
    func setupThemeIndonesia() {
        thaiCheckboxView.backgroundColor = UIColor.clear
        englishCheckboxView.backgroundColor = UIColor.clear
        vietnameseCheckboxView.backgroundColor = UIColor.clear
        singaporeCheckboxView.backgroundColor = .clear
        indonesiaCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
    }
    
    func setupThemeSingapore() {
        thaiCheckboxView.backgroundColor = UIColor.clear
        englishCheckboxView.backgroundColor = UIColor.clear
        vietnameseCheckboxView.backgroundColor = UIColor.clear
        indonesiaCheckboxView.backgroundColor = UIColor.clear
        singaporeCheckboxView.backgroundColor = UIColor(named: "app_theme_color")
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

    func changeLanguage(_ language: Currency) {
        //Set default language as app language
        UserDefaults.persistAppCurrencyCode(language: language)
        checkout?.changeCurrency(currency: language.code)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            NotificationCenter.default.post(name: NSNotification.Name("ReloadData"), object: language)
        }
        
    }
}
