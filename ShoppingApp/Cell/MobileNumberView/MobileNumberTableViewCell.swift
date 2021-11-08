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
import OTPInputView

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
        return mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
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
    
    @IBOutlet weak var OTPView: OTPInputView! {
        didSet {
            OTPView.delegateOTP = self
        }
    }
    
    @IBOutlet weak var verifyButton: UIButton! {
        didSet {
            verifyButton.backgroundColor = UIColor(named: "app_theme_color")
            verifyButton.layer.cornerRadius = 5
            verifyButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    @IBAction func onClickVerifyButton(_ sender: UIButton) {
        if(viewType == .mobile) {
            checkOut?.getOTP(formattedMobileNumber ?? "", onCompletionHandler: { (result) in
                switch result {
                case .success(let data):
                    self.viewType = .otp
                    self.changeToOTPView()
                case.failure(let error):
                    print(error)
                    break
                }
            })
            
        } else if(viewType == .otp) {
            //API
            delegate?.fetchSavedCards(formattedMobileNumber ?? "", otpText)
        }
    }
    
    func changeToMobileView() {
        DispatchQueue.main.async {
            self.verifyButton.setTitle("Next", for: .normal)
            self.OTPView.isHidden = true
            self.mobileTextField.isHidden = false
            self.titleLabel.text = "enter_mobile_no".localized
            self.titleLabel.textAlignment = .left
        }
    }
    
    func changeToOTPView() {
        DispatchQueue.main.async {
            self.OTPView.isHidden = false
            self.mobileTextField.isHidden = true
            self.verifyButton.setTitle("Verify", for: .normal)
            self.titleLabel.text = "otp_has_been_sent".localized + " \(self.formattedMobileNumber ?? "")"
            self.titleLabel.textAlignment = .center
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        changeToMobileView()
    }
}

extension MobileNumberTableViewCell {
    func layout(basedOn viewType: MobileNumberViewType) {
        self.viewType = viewType
        switch viewType {
        case .otp:
            self.changeToOTPView()
            mobileNumber = UserDefaults.getMobileNumber ?? ""
        case .mobile:
            break
        }
    }
}

extension MobileNumberTableViewCell: OTPViewDelegate {
    
    func didFinishedEnterOTP(otpNumber: String) {
        otpText = otpNumber
    }
    
    func otpNotValid() {
        
    }
}
