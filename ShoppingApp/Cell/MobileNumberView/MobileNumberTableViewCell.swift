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
    
    let number = UserDefaults.getMobileNumber ?? ""
    var formattedMobileNumber: String? {
        return number.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mobileTextField: PhoneNumberTextField! {
        didSet {
            mobileTextField.withExamplePlaceholder = true
            mobileTextField.withFlag = true
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
            self.titleLabel.text = "Enter Phone No."
            self.titleLabel.textAlignment = .left
        }
    }
    
    func changeToOTPView() {
        DispatchQueue.main.async {
            self.OTPView.isHidden = false
            self.verifyButton.setTitle("Verify", for: .normal)
            self.mobileTextField.isHidden = true
            self.titleLabel.text = "Enter the authentication code sent on your \(self.formattedMobileNumber ?? "")"
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
            self.layoutIfNeeded()
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
