//
//  SNTabBarViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 20/10/21.
//

import UIKit

class SNTabBarViewController: UITabBarController {
    
    private let selectedTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .regular)]
    
    private let normalTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .regular)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setupTabControllers() {
        let productListVC: ProductListViewController = ViewControllersFactory.viewController()
        productListVC.tabBarItem = UITabBarItem(title: "home".localized, image: UIImage(named: "icon_selected_home"), selectedImage: UIImage(named: "icon_selected_home"))
        productListVC.tabBarItem.setTitleTextAttributes(normalTitleAttributes, for: .normal)
        productListVC.tabBarItem.setTitleTextAttributes(selectedTitleAttributes, for: .selected)
        productListVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let profileVC: ProfileViewController = ViewControllersFactory.viewController()
        profileVC.tabBarItem = UITabBarItem(title: "profile".localized, image: UIImage(named: "icon_selected_profile"), selectedImage: UIImage(named: "icon_selected_profile"))
        profileVC.tabBarItem.setTitleTextAttributes(normalTitleAttributes, for: .normal)
        profileVC.tabBarItem.setTitleTextAttributes(selectedTitleAttributes, for: .selected)
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let productListVC3: MoreViewController = ViewControllersFactory.viewController()
        productListVC3.tabBarItem = UITabBarItem(title: "action_settings".localized, image: UIImage(named: "icon_selected_more"), selectedImage: UIImage(named: "icon_selected_more"))
        productListVC3.tabBarItem.setTitleTextAttributes(normalTitleAttributes, for: .normal)
        productListVC3.tabBarItem.setTitleTextAttributes(selectedTitleAttributes, for: .selected)
        
        productListVC3.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        var viewControllers: [UIViewController] = []
        viewControllers = [productListVC, profileVC, productListVC3]
        self.viewControllers = viewControllers.map { applyTheme(for: $0) }.map { UINavigationController(rootViewController: $0) }
        self.selectedIndex = 0
    }
    
    fileprivate func applyTheme(for controller: UIViewController) -> UIViewController {
        controller.setupNavBarTitleTheme()
        return controller
    }
}
