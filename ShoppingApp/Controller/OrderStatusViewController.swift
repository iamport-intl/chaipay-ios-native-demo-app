//
//  OrderStatusViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 25/10/21.
//

import UIKit
import ChaiPayPaymentSDK

protocol OrderStatusDelegate: AnyObject {
    func goBack(fromSuccess: Bool)
}

enum ResponseDataSource {
    case orderDetails
    case productsList(_ products: [ProductDetailsObject])
    case shippingAddress
}

class OrderStatusViewController: UIViewController {
    
    @IBOutlet weak var responseTypeImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var buttonTitle: UIButton! {
        didSet {
            buttonTitle.layer.cornerRadius = 8
        }
    }
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: OrderStatusDelegate?
    var response: WebViewResponse?
    var selectedProducts: [ProductDetailsObject] = []
    var amount: Int = 0
    var delivery: Int = 0
    var isSuccess: Bool = false
    private var dataSource: [ResponseDataSource] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupTableView()
        registerCells()
        setLayout()
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
    
    func setLayout() {
       
        responseTypeImage.image = UIImage(named: isSuccess ? "icon_success" : "icon_failed")
        headerTitle.text = isSuccess ? "Payment Successful" : "Payment failed"
        descriptionTitle.text =  isSuccess ? "Thank you for shopping with us." : "Please try again"
        buttonTitle.setTitle(isSuccess ? "Continue" : "Go Back", for: .normal)
        buttonTitle.backgroundColor =  UIColor(named: isSuccess ? "success_green_color" : "app_theme_color")
    }
    
    func setupDataSource() {
        dataSource = []
        let orderDetailsData = ResponseDataSource.orderDetails
        let productsData = ResponseDataSource.productsList(selectedProducts)
        let shippingData = ResponseDataSource.shippingAddress
        dataSource = [orderDetailsData, productsData, shippingData]
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        delegate?.goBack(fromSuccess: isSuccess)
    }
}

extension OrderStatusViewController: UITableViewDataSource, UITableViewDelegate {
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
            print("RESPONE !)$", response)
            cell.layout(basedOn: response, amount: amount, delivery: self.delivery)
            cell.selectionStyle = .none
            return cell
            
        case .productsList(let products):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellIdentifier) as? ProductTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.selectionStyle = .none
            cell.layout(basedOn: products[indexPath.row])
            return cell
            
        case .shippingAddress:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentShippingAddressTableViewCell.cellIdentifier) as? PaymentShippingAddressTableViewCell else {
                return UITableViewCell(frame: .zero)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
