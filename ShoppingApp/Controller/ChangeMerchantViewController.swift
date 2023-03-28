//
//  ChangeMerchantViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 05/11/21.
//

import UIKit
import ChaiPayPaymentSDK

class ChangeMerchantViewController: UIViewController {
    
    var checkout: Checkout? {
        return AppDelegate.shared.checkout
    }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = NSLocalizedString("Change_Merchant_Sub_Title", comment: "")
        }
    }
    
    @IBOutlet weak var chaipayKeyLabel: UILabel!
    
    @IBOutlet weak var secretKeyLabel: UILabel!
    
    @IBOutlet weak var environmentLabel: UILabel!
    
    @IBOutlet weak var devEnvironmentLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var chaipayKeyText: UITextField!
    @IBOutlet weak var secretKeyText: UITextField!
    @IBOutlet weak var environmentSegmentControl: UISegmentedControl!
    @IBOutlet weak var devEnvironmentSegmentControl: UISegmentedControl!
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
           switch environmentSegmentControl.selectedSegmentIndex
           {
           case 0:
               UserDefaults.persistEnv(environmentObject: EnvObject(index: 0, environmentTitle: "Sandbox", envType: "sandbox"))
               
           case 1:
               UserDefaults.persistEnv(environmentObject: EnvObject(index: 1, environmentTitle: "Live", envType: "live"))
           default:
               break;
           }
        checkout?.changeEnvironment(envType: UserDefaults.getEnvironment!.envType)
       }
    
    @IBAction func devIndexChanged(sender: UISegmentedControl) {
           switch devEnvironmentSegmentControl.selectedSegmentIndex
           {
           case 0:
               
               UserDefaults.persistDevEnv(envObj: DevEnvObject(index: 0, environmentTitle: "Dev", envType: "dev"))
               //show popular view
           case 1:
               
               UserDefaults.persistDevEnv(envObj: DevEnvObject(index: 1, environmentTitle: "Staging", envType: "staging"))
               
               
           default:
               UserDefaults.persistDevEnv(envObj: DevEnvObject(index: 2, environmentTitle: "Prod", envType: "prod"))
           }
        checkout?.changeDevEnvironment(envType: UserDefaults.getDevEnv!.envType)
       }
    
    private var dataSource: [EnvironmentObject] = []
    
    var selectedEnvironment: EnvironmentObject? {
        return UserDefaults.getSelectedEnvironment
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = EnvironmentDataManager.prepareEnvironmentData()
        chaipayKeyText.addTarget(self, action: #selector(chaipayTextFieldDidChange(_:)), for: .editingChanged)
        secretKeyText.addTarget(self, action: #selector(secretKeyFieldDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        
        setUpMerchantdetails()
//        setupTableView()
//        registerCell()
    }
    
    @objc func onSave() {
        
        checkout?.changeDevEnvironment(envType: UserDefaults.getDevEnv!.envType)
        checkout?.changeEnvironment(envType: UserDefaults.getEnvironment!.envType)
        checkout?.changeSecretKey(key: (UserDefaults.getSecretKey ?? chaipayKeyText.text) ?? "")
        checkout?.changeChaipayKey(key: (UserDefaults.getChaipayKey ?? secretKeyText.text) ?? "")
        self.dismiss(animated: true)
    }
    
    
    @objc func chaipayTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            UserDefaults.persistChaipayKey(key: text)
        }
        
    }
    
    @objc func secretKeyFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            UserDefaults.persistSecretKey(key: text)
        }
    }
    
    func setUpMerchantdetails() {
        let chaipaykey = UserDefaults.getChaipayKey
        let secretKey = UserDefaults.getSecretKey
        
        
        let environmentType = UserDefaults.getEnvironment
        environmentSegmentControl.selectedSegmentIndex = environmentType?.index ?? 0
        
        let devEnvType = UserDefaults.getDevEnv
        devEnvironmentSegmentControl.selectedSegmentIndex = devEnvType?.index ?? 0
        
        chaipayKeyText.text = chaipaykey
        secretKeyText.text = secretKey
    }
    
//    func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.estimatedRowHeight = 80
//        tableView.tableFooterView = UIView()
//    }
//
//    func registerCell() {
//        tableView.registerCell(SelectEnvironmentTableViewCell.cellIdentifier)
//    }
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
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

