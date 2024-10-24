//
//  PaymentMethodTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 06/09/21.
//

import ChaiPayPaymentSDK
import UIKit
import SDWebImage

protocol PaymentMethodDelegate: AnyObject {
    func selectedPaymentMethod(method: PaymentMethodObject)
    func selectedSavedCard(method: SavedCard)
    func newCardDetails(cardDetails: CardDetails)
}
class PaymentMethodTableViewCell: UITableViewCell {
   
    var cellHeight: CGFloat = 50
    var paymentMethodObject: PaymentMethodObject?
    var selectedSavedCard: SavedCard?
    weak var delegate: PaymentMethodDelegate?
    @IBOutlet var paymentTypeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var expandableImageView: UIImageView!
    @IBOutlet var tableviewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var shadowView: UIView! {
        didSet {
            shadowView.applyShadow()
            shadowView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet var cardTypeOneImageView: UIImageView! {
        didSet {
            cardTypeOneImageView.isHidden = true
        }
    }

    @IBOutlet var cardTypeTwoImageView: UIImageView! {
        didSet {
            cardTypeTwoImageView.isHidden = true
        }
    }

    @IBOutlet var cardTypeThreeImageView: UIImageView! {
        didSet {
            cardTypeThreeImageView.isHidden = true
        }
    }

    @IBOutlet var countLabel: UILabel! {
        didSet {
            countLabel.isHidden = true
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
        }
    }
    
    @IBOutlet var newCardView: NewCardView! {
        didSet {
            newCardView.isHidden = true
            newCardView.applyShadow()
            newCardView.layer.cornerRadius = 5
            newCardView.delegate = self
        }
    }

    var paymentMethodObjects: [PaymentMethodObject] = []
    
    var savedCardObjects: [SavedCard] = []
    var fromSavedCard: Bool = false
    
    static let cellIdentifier = String(describing: PaymentMethodTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCell()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
    }
    
    func registerCell() {
        tableView.registerCell(ListOfPaymentMethodsTableViewCell.cellIdentifier)
    }
    
    override func prepareForReuse() {
        paymentMethodObjects = []
        savedCardObjects = []
        
        DispatchQueue.main.async {
            
        }
    }
}

extension PaymentMethodTableViewCell {
    func layout(basedOn datasource: PaymentMethodDataSource, paymentMethodObject: PaymentMethodObject?, savedCard: SavedCard?){
        paymentTypeImageView.image = datasource.type.image
        titleLabel.text = datasource.type.title
        expandableImageView.image = UIImage(named: datasource.isExpanded ? "icon_expand" : "icon_collapse")
        self.paymentMethodObject = paymentMethodObject
        self.selectedSavedCard = savedCard
        paymentMethodObjects = []
        savedCardObjects = []
        tableView.isHidden = true
        newCardView.isHidden = true
        
        cardTypeOneImageView.isHidden = true
        cardTypeTwoImageView.isHidden = true
        cardTypeThreeImageView.isHidden = true
        countLabel.isHidden = true
        
        switch datasource.type {
        case .newCreditCard :
            newCardView.isHidden = !datasource.isExpanded
            
        case .savedCards:
            savedCardObjects = datasource.cardPayments
            createStackViewImages(values: datasource.cardPayments)
            tableView.isHidden = !datasource.isExpanded
            fromSavedCard = true
            tableviewHeightConstraint.constant = datasource.isExpanded ? cellHeight * CGFloat(datasource.cardPayments.count) : 0
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        default:
            paymentMethodObjects = datasource.paymentMethods
            createStackViewImages(values: datasource.paymentMethods)
            tableView.isHidden = !datasource.isExpanded
            tableviewHeightConstraint.constant = datasource.isExpanded ? cellHeight * CGFloat(datasource.paymentMethods.count) : 0
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func createStackViewImages(values: [PaymentMethodObject]) {
        switch values.count {
        case 0: break
        case 1:
            cardTypeOneImageView.isHidden = false
            let url = URL(string: values[0].logo)
            cardTypeOneImageView.sd_setImage(with: url, placeholderImage: nil)
            
        case 2:
            cardTypeOneImageView.isHidden = false
            let url = URL(string: values[0].logo)
            cardTypeOneImageView.sd_setImage(with: url, placeholderImage: nil)

            
            cardTypeTwoImageView.isHidden = false
            let urlTwo = URL(string: values[1].logo)
            cardTypeTwoImageView.sd_setImage(with: urlTwo, placeholderImage: nil)

        case 3:
            cardTypeOneImageView.isHidden = false
            let url = URL(string: values[0].logo)
            cardTypeOneImageView.sd_setImage(with: url, placeholderImage: nil)

            
            cardTypeTwoImageView.isHidden = false
            let urlTwo = URL(string: values[1].logo)
            cardTypeTwoImageView.sd_setImage(with: urlTwo, placeholderImage: nil)

            cardTypeThreeImageView.isHidden = false
            cardTypeThreeImageView.image = UIImage(named: values[2].logo)

        default:

            cardTypeOneImageView.isHidden = false
            let url = URL(string: values[0].logo)
            cardTypeOneImageView.sd_setImage(with: url, placeholderImage: nil)

            
            cardTypeTwoImageView.isHidden = false
            let urlTwo = URL(string: values[1].logo)
            cardTypeTwoImageView.sd_setImage(with: urlTwo, placeholderImage: nil)

            cardTypeThreeImageView.isHidden = false
            let urlThree = URL(string: values[2].logo)
            cardTypeThreeImageView.sd_setImage(with: urlThree, placeholderImage: nil)
            
            countLabel.isHidden = false
            countLabel.text = "+\(values.count - 3)"
        }
   }
    
    func createStackViewImages(values: [SavedCard]) {
        let x = Set(values.map{ result in return result.type})
        let uniqueValues = Array(x)
        switch uniqueValues.count {
        case 0: break
        case 1:
            var imageName: String = ""
            switch uniqueValues.first {
            case "visa":
                imageName = "visa"
            case "mastercard":
                imageName = "masterCard"
            case "jcb":
                imageName = "jcb"
            default:
                imageName = "jcb"
            }
            cardTypeThreeImageView.isHidden = false
            cardTypeThreeImageView.image = UIImage(named: imageName)

        case 2:
            var imageName: String = ""
            
            switch uniqueValues.first {
            case "visa":
                imageName = "visa"
            case "mastercard":
                imageName = "masterCard"
            case "jcb":
                imageName = "jcb"
            default:
                imageName = "jcb"
            }
            cardTypeTwoImageView.isHidden = false
            cardTypeTwoImageView.image = UIImage(named: imageName)
            
            
            switch uniqueValues[1] {
            case "visa":
                imageName = "visa"
            case "mastercard":
                imageName = "masterCard"
            case "jcb":
                imageName = "jcb"
            default:
                imageName = "jcb"
            }
            cardTypeThreeImageView.isHidden = false
            cardTypeThreeImageView.image = UIImage(named: imageName)

        case 3:
            if(uniqueValues.contains("visa")) {
                cardTypeThreeImageView.isHidden = false
                cardTypeThreeImageView.image = UIImage(named: "visa")
            }
            
            if(uniqueValues.contains("mastercard")) {
                cardTypeTwoImageView.isHidden = false
                cardTypeTwoImageView.image = UIImage(named: "masterCard")
            }
            
            cardTypeOneImageView.isHidden = false
            if(uniqueValues.contains("jcb")) {
                cardTypeOneImageView.image = UIImage(named: "jcb")
            } else {
                cardTypeOneImageView.image = UIImage(named: "jcb")
            }
        default:
            
            if(uniqueValues.contains("visa")) {
                cardTypeThreeImageView.isHidden = false
                cardTypeThreeImageView.image = UIImage(named: "visa")
            }
            
            if(uniqueValues.contains("mastercard")) {
                cardTypeTwoImageView.isHidden = false
                cardTypeTwoImageView.image = UIImage(named: "masterCard")
            }
            
            cardTypeOneImageView.isHidden = false
            if(uniqueValues.contains("jcb")) {
                cardTypeOneImageView.image = UIImage(named: "jcb")
            } else {
                cardTypeOneImageView.image = UIImage(named: "jcb")
            }
            
            countLabel.isHidden = false
            countLabel.text = "+\(uniqueValues.count - 3)"
        }
    }
}

extension PaymentMethodTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fromSavedCard ? savedCardObjects.count : paymentMethodObjects.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListOfPaymentMethodsTableViewCell.cellIdentifier) as? ListOfPaymentMethodsTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if fromSavedCard {
            let isSelected = savedCardObjects[indexPath.row].partialCardNumber == selectedSavedCard?.partialCardNumber
            cell.layout(basedOn: savedCardObjects[indexPath.row], isSelected: isSelected)
        } else {
            guard paymentMethodObjects.count > indexPath.row else {
                return cell
            }
            let isSelected = paymentMethodObjects[indexPath.row].paymentChannelKey == paymentMethodObject?.paymentChannelKey
            cell.layout(basedOn: paymentMethodObjects[indexPath.row], isSelected: isSelected)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if fromSavedCard {
            delegate?.selectedSavedCard(method: savedCardObjects[indexPath.row])
        } else {
            delegate?.selectedPaymentMethod(method: paymentMethodObjects[indexPath.row])
        }
        
    }
}

extension PaymentMethodTableViewCell: NewCardDataDelegate {
    func cardDetails(_ details: CardDetails) {
        delegate?.newCardDetails(cardDetails: details)
    }
}
