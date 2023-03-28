//
//  MobileNumberTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 08/09/21.
//

import UIKit
import Foundation
import ChaiPayPaymentSDK
import PhoneNumberKit

enum MobileNumberViewType {
    case mobile, otp
}

protocol MobileNumberViewDelegate: AnyObject {
    func fetchSavedCards(_ mobileNumber: String, _ OTP: String)
}
class MobileNumberTableViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: MobileNumberTableViewCell.self)
    
    var delegate: MobileNumberViewDelegate?
    var viewType: MobileNumberViewType = .mobile
    var checkOut: Checkout?
    var otpText:String = ""
    
    var mobileNumber = UserDefaults.getMobileNumber ?? ""
    var formattedMobileNumber: String? {
        return (UserDefaults.getMobileNumber ?? "").trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
    }
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.applyShadow()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mobileTextField: PhoneNumberTextField! {
        didSet {
            mobileTextField.isHidden = true
            mobileTextField.withExamplePlaceholder = true
            mobileTextField.withFlag = true
            mobileTextField.textContentType = .oneTimeCode
        }
    }
    
    @IBOutlet weak var otpFieldView: OTPFieldView!
     
    @IBOutlet weak var verifyButton: UIButton! {
        didSet {
            verifyButton.backgroundColor = UIColor(named: "app_theme_color")
            verifyButton.layer.cornerRadius = 5
            verifyButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBAction func onClickVerifyButton(_ sender: UIButton) {
        if(viewType == .mobile) {
            print("mobileTextField.text", mobileTextField.text)
            guard let num = mobileTextField.text else {
                 return
            }
            UserDefaults.persistMobileNumber(number: num )
            checkOut?.getOTP(num.removeWhitespace() ?? "", onCompletionHandler: { (result) in
                switch result {
                case .success(let data):
                    self.changeToOTPView()
                case.failure(let error):
                    print(error)
                    break
                }
            })
            
        } else if(viewType == .otp) {
            //API
            delegate?.fetchSavedCards(formattedMobileNumber ?? "", otpText)
            otpFieldView.initializeUI()
            
        }
    }
    
    
    func setupOtpView(){
        otpFieldView.fieldsCount = 6
        otpFieldView.fieldBorderWidth = 2
        otpFieldView.defaultBorderColor = UIColor.black
        otpFieldView.filledBorderColor = UIColor(named: "app_theme_color") ?? UIColor.red
        otpFieldView.cursorColor = UIColor(named: "app_theme_color") ?? UIColor.red
        otpFieldView.displayType = .roundedCorner
        otpFieldView.fieldSize = 40
        otpFieldView.filledBorderColor = UIColor(named: "app_theme_color") ?? UIColor.red
        otpFieldView.defaultBorderColor = UIColor.lightGray
//        otpTextFieldView.separatorSpace = 30
        otpFieldView.shouldAllowIntermediateEditing = false
        otpFieldView.delegate = self
        otpFieldView.initializeUI()
    }
    
    func changeToMobileView() {
        DispatchQueue.main.async {
            self.viewType = .mobile
            self.verifyButton.setTitle("Next", for: .normal)
            self.otpFieldView.isHidden = true
            self.mobileTextField.isHidden = false
            self.titleLabel.text = "enter_mobile_no".localized
            self.titleLabel.textAlignment = .left
        }
    }
    
    func changeToOTPView() {
        DispatchQueue.main.async {
            self.viewType = .otp
            self.otpFieldView.isHidden = false
            self.mobileTextField.isHidden = true
            self.verifyButton.setTitle("Verify", for: .normal)
            self.titleLabel.text = "otp_has_been_sent".localized + " \(self.formattedMobileNumber ?? "")"
            self.titleLabel.textAlignment = .center
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        changeToMobileView()
        setupOtpView()
    }
}

extension MobileNumberTableViewCell {
    func layout(basedOn viewType: MobileNumberViewType) {
        
        switch viewType {
        case .otp:
            
            self.changeToOTPView()
            mobileNumber = UserDefaults.getMobileNumber ?? ""
        case .mobile:
            
            break
        }
    }
}

extension MobileNumberTableViewCell: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        otpText = otpString
        print("OTPString: \(otpString)")
    }
}
