//
//  ResponseView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 09/09/21.
//

import UIKit
import PortoneSDK

protocol ResponseViewDelegate: AnyObject {
    func goBack(fromSuccess: Bool)
}
class ResponseView: UIView {

    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.applyShadow()
            shadowView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.applyShadow()
            containerView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var responseTypeImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var buttonTitle: UIButton! {
        didSet {
            buttonTitle.layer.cornerRadius = 8
        }
    }
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: ResponseViewDelegate?
    var isSuccess: Bool = false
    var dataSource: [ResponseDataSource] = []
    var selectedProducts: [ProductDetailsObject] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        registerCells()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
    }
    
    func registerCells() {
        tableView.registerCells([PaymentShippingAddressTableViewCell.cellIdentifier, OrderDetailsTableViewCell.cellIdentifier, ProductTableViewCell.cellIdentifier])
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        delegate?.goBack(fromSuccess: isSuccess)
    }
}

extension ResponseView {
    func setLayout(isSuccess: Bool, amount: String, _ response: TransactionResponse?, selectedProducts: [ProductDetailsObject] = []) {
        responseTypeImage.image = UIImage(named: isSuccess ? "icon_success" : "icon_failed")
        headerTitle.text = isSuccess ? "Payment Successful" : "Payment failed"
        descriptionTitle.text =  isSuccess ? "Thank you for shopping with us." : "Please try again"
        self.isSuccess = isSuccess
        buttonTitle.setTitle(isSuccess ? "Continue" : "Go Back", for: .normal)
        buttonTitle.backgroundColor =  UIColor(named: isSuccess ? "success_green_color" : "app_theme_color")
        
        self.selectedProducts = selectedProducts
        setupDataSource()
    }
    
    func setupDataSource() {
        dataSource = []
        let orderDetailsData = ResponseDataSource.orderDetails
        let productsData = ResponseDataSource.productsList(selectedProducts)
        let shippingData = ResponseDataSource.shippingAddress
        dataSource = [orderDetailsData, productsData, shippingData]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ResponseView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataSource[section] {
        case .productsList(let products):
            return products.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.section] {
        case .orderDetails:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailsTableViewCell.cellIdentifier) as? OrderDetailsTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            return cell
            
        case .productsList(let products):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellIdentifier) as? ProductTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.layout(basedOn: products[indexPath.row])
            return cell
            
        case .shippingAddress:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentShippingAddressTableViewCell.cellIdentifier) as? PaymentShippingAddressTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
