//
//  ChangeMerchantViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 05/11/21.
//

import UIKit

class ChangeMerchantViewController: UIViewController {
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = NSLocalizedString("Change_Merchant_Sub_Title", comment: "")
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    private var dataSource: [EnvironmentObject] = []
    
    var selectedEnvironment: EnvironmentObject? {
        return UserDefaults.getSelectedEnvironment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = EnvironmentDataManager.prepareEnvironmentData()
        setupTableView()
        registerCell()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.tableFooterView = UIView()
    }
    
    func registerCell() {
        tableView.registerCell(SelectEnvironmentTableViewCell.cellIdentifier)
    }
}

extension ChangeMerchantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectEnvironmentTableViewCell.cellIdentifier) as? SelectEnvironmentTableViewCell else {
            return UITableViewCell()
        }
        cell.layout(basedOn: dataSource[indexPath.row], isSelected: dataSource[indexPath.row].key == selectedEnvironment?.key)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard dataSource[indexPath.row].key != selectedEnvironment?.key else {
            return
        }
        
        UserDefaults.removeMobileNumber()
        UserDefaults.removeAuthorisationToken()
        
        NotificationCenter.default.post(name: .MerchantUpdated, object: nil)
        
        UserDefaults.persistEnvironment(dataSource[indexPath.row])
        AppDelegate.shared.initializeChaiPay()
        
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

