//
//  NewCardView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 07/09/21.
//

import UIKit
import ChaiPayPaymentSDK
import CreditCardValidator

protocol NewCardDataDelegate: AnyObject {
    func cardDetails(_ details: CardDetails)
}

class NewCardView: UIView {
    @IBOutlet weak var inlineErrorLabel: UILabel!
    @IBOutlet weak var cardHolderNameTextField: UITextField! {
        didSet {
            cardHolderNameTextField.autocapitalizationType = .words
            cardHolderNameTextField.delegate = self
            cardHolderNameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
    }
    @IBOutlet weak var cardNumberTextField: UITextField! {
        didSet {
            setRightImage()
            cardNumberTextField.keyboardType = .numberPad
            cardNumberTextField.delegate = self
            cardNumberTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
    }
    @IBOutlet weak var expiryDateTextField: UITextField! {
        didSet {
            expiryDateTextField.keyboardType = .numberPad
            expiryDateTextField.delegate = self
            expiryDateTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
    }
    @IBOutlet weak var cvvTextField: UITextField! {
        didSet {
            cvvTextField.keyboardType = .numberPad
            cvvTextField.delegate = self
            cvvTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        }
    }
    
    var cardHolderName: String {
        return cardHolderNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    var cardNumber: String {
        return cardNumberTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    var expiryMonth: String = ""
    var expiryYear: String = ""
    var cvv: String {
        return cvvTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
    }
    
    weak var delegate: NewCardDataDelegate?
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    func setRightImage() {
        cardNumberTextField.rightViewMode = .always
        let view = UIView(frame: CGRect(x: -5, y: 0, width: 24, height: 24))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 14, height: 14))
        let image = UIImage(named: "credit-card")
        imageView.image = image
        view.addSubview(imageView)
        cardNumberTextField.rightView = view
    }
    
    public enum CreditCardType1: String {
        case amex = "^3[47][0-9]{5,}$"
        case visa = "^4[0-9]{6,}$"
        case masterCard = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
        case maestro = "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        case dinersClub = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case jcb = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case discover = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case unionPay = "^62[0-5]\\d{13,16}$"
        case mir = "^2[0-9]{6,}$"
        
        var title : String {
            switch self {
            case .amex:
                return "amex"
            case .visa:
                return "visa"
            case .masterCard:
                return "masterCard"
            case .maestro:
                return "maestro"
            case .dinersClub:
                return "dinersClub"
            case .jcb:
                return "jcb"
            case .discover:
                return "discover"
            case .unionPay:
                return "unionPay"
            case .mir:
                return "mir"
            }
        }
    }
    var cardType = ""   
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        
        if cardHolderNameTextField == textField  {
            delegate?.cardDetails(CardDetails(token: nil, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cardHolderName: cardHolderName, type: cardType, cvv: cvv))
        } else if cardNumberTextField == textField {
            if cardNumber.count > 15 {
                let validator = CreditCardValidator(cardNumber)
                print(validator)
                
                if(validator.isValid) {
                    hideNumberInlineError()
                    cardType = CreditCardType1(rawValue: validator.type?.rawValue ?? "")?.title ?? ""
                } else {
                    showNumberInlineError()
                }
            }
            
            var targetCursorPosition = 0
            if let startPosition = textField.selectedTextRange?.start {
                targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
            }
            
            var cardNumberWithoutSpaces = ""
            cardNumberWithoutSpaces = self.removeNonDigits(string: cardNumber, andPreserveCursorPosition: &targetCursorPosition)
            
            if cardNumberWithoutSpaces.count > 19 {
                textField.text = previousTextFieldContent
                textField.selectedTextRange = previousSelection
                return
            }
            
            let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces
            
            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
            delegate?.cardDetails(CardDetails(token: nil, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cardHolderName: cardHolderName, type: cardType, cvv: cvv))
            
        } else if expiryDateTextField == textField {
            if((textField.text ?? "").count > 8) {
                expiryMonth = String(textField.text!.dropLast(7))
                expiryYear = String(textField.text!.dropFirst(5))
            }
            delegate?.cardDetails(CardDetails(token: nil, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cardHolderName: cardHolderName, type: cardType, cvv: cvv))
        } else {
            delegate?.cardDetails(CardDetails(token: nil, cardNumber: cardNumber, expiryMonth: expiryMonth, expiryYear: expiryYear, cardHolderName: cardHolderName, type: cardType, cvv: cvv))
        }
    }
    
    func showNumberInlineError() {
        inlineErrorLabel.text = "Not a valid card number"
    }
    
    func hideNumberInlineError() {
        inlineErrorLabel.text = ""
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
        ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
}

extension NewCardView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == expiryDateTextField {
            guard string != "" else {
                return true
            }
            if (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").count >= 9 {
                return false
            }
            
            if (textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").count == 1 {
                var  text = textField.text ?? ""
                text += string
                textField.text = text + " / "
                return false
            }
        }
        previousTextFieldContent = textField.text
        previousSelection = textField.selectedTextRange
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
