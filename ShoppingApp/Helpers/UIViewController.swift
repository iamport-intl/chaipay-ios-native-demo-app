//
//  UIViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    func showHUD() {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.bezelView.color = .black
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    
    func setupThemedNavbar(tintColor: UIColor = .black, barTintColor: UIColor = .white, isTranslucent: Bool = false) {
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.barTintColor = barTintColor
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func setupNavBarLargeTitleTheme(title: String? = nil, color: UIColor = .black) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: color]
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupNavBarTitleTheme(color: UIColor = .black) {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
    }
    
    func setupBackButton(title: String = "") {
        var backButtonItem = UIBarButtonItem()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_left_arrow")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_left_arrow")
        backButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
    
    // MARK: - Keyboard Handling
    
    public func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillChange),
            name: NSNotification.Name(rawValue: "UIKeyboardWillChangeFrameNotification"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"),
            object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {}
    
    @objc func keyboardWillHide(notification: NSNotification) {}
    
    @objc func keyboardWillChange(notification: NSNotification) {}
}

extension UITableView {
    func registerCell(_ cellIdentifier: String) {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func registerCells(_ cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            let nib = UINib(nibName: identifier, bundle: nil)
            self.register(nib, forCellReuseIdentifier: identifier)
        }
    }
    
    func registerSectionHeaderFooter(_ cellIdentifier: String) {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: cellIdentifier)
    }
    
    func registerSectionHeaderFooters(_ cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            let nib = UINib(nibName: identifier, bundle: nil)
            self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
}

extension UICollectionView {
    func registerCell(_ cellIdentifier: String) {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func registerCells(_ cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            registerCell(identifier)
        }
    }
    
    func registerSectionHeaderFooter(_ cellIdentifier: String) {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellIdentifier)
    }
}

extension Double {
    func roundOf(to places: Int) -> Double {
        let referenceValue: Double = pow(10.0, Double(places))
        let roundedValue = Double(Int(self * referenceValue)) / referenceValue
        return roundedValue
    }
}

extension Int {
    func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< self).map { _ in letters.randomElement()! })
    }
}

extension UIView {
    func applyShadow(shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 4, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowColor: UIColor = .lightGray) {
        self.layer.shadowOffset = shadowOffset // Here you control x and y
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
    }
}

extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
