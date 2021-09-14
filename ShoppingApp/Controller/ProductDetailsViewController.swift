//
//  ProductDetailsViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var payNowButton: UIButton! {
        didSet {
            payNowButton.layer.cornerRadius = 10
        }
    }

    // MARK: - Properties

    var selectedProductsDict: [String: ProductDetailsObject] = [:]
    var selectedProducts: [ProductDetailsObject] = []
    var productDetailsDataSource: ProductDetailsDataSource?
    var delivery: Double = 149

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       // setupThemedNavbar()
        setupNavBarLargeTitleTheme(title: "Checkout", color: .black)
        setupNavBarTitleTheme(color: .black)
        setupInitialData()
        registerCells()
        setupTableView()
    }

    func setupInitialData() {
        productDetailsDataSource = ProductDetailsDataSource()
        selectedProducts = Array(selectedProductsDict.values)

        setupDataSource()
    }

    func setupDataSource() {
        var detailsSectionItems: [DetailsSectionItem] = []

        let productDetailsDataModel = ProductDetailsDataModel(datasource: selectedProducts)

        let sumOfOrders = selectedProducts.map { $0.price ?? 0.0 }.reduce(0.0, +)
        let formattedSumOfOrdersText = (selectedProducts.first?.currency ?? "") + "\(sumOfOrders)"
        let deliveryFormattedText = "\(selectedProducts.first?.currency ?? "")" + "\(delivery)"

        let summary = sumOfOrders + delivery
        let formattedSummaryText = "\(selectedProducts.first?.currency ?? "")" + "\(summary)"

        let summaryObject = SummaryObject(orderTitle: "Order", orderValue: formattedSumOfOrdersText, deliveryTitle: "Delivery", deliveryValue: deliveryFormattedText, summaryTitle: "Summary", summaryValue: formattedSummaryText)
        let productSummaryDataModel = ProductSummaryDataModel(summaryObject: summaryObject)

        let productPaymentDataModel = ProductPaymentDataModel()
        detailsSectionItems = [productDetailsDataModel, productPaymentDataModel, productSummaryDataModel]

        productDetailsDataSource?.items = detailsSectionItems
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
    }

    func registerCells() {
        let cellIdentifiers = [ProductTableViewCell.cellIdentifier, ProductPaymentTableViewCell.cellIdentifier, SummaryTableViewCell.cellIdentifier]
        tableView.registerCells(cellIdentifiers)
    }

    @IBAction func onClickPayNowButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Payment Success", message: "Thank you for shopping with us.", preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Okay", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension ProductDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return productDetailsDataSource?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetailsDataSource?.items[section].rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = productDetailsDataSource?.items[indexPath.section]
        switch item?.type {
        case .details:
            guard let datasource = (item as? ProductDetailsDataModel)?.datasource, let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellIdentifier) as? ProductTableViewCell else {
                return UITableViewCell()
            }
            cell.layout(basedOn: datasource[indexPath.row])
            return cell

        case .payment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductPaymentTableViewCell.cellIdentifier) as? ProductPaymentTableViewCell else {
                return UITableViewCell()
            }
            return cell

        case .summary:
            guard let summaryObject = (item as? ProductSummaryDataModel)?.summaryObject, let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.cellIdentifier) as? SummaryTableViewCell else {
                return UITableViewCell()
            }
            cell.layout(basedOn: summaryObject)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return productDetailsDataSource?.items[section].headerHeight ?? 0.01
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return productDetailsDataSource?.items[section].footerHeight ?? 0.01
    }
}
