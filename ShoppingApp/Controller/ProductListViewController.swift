//
//  ProductListViewController.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import UIKit

enum SortType {
    case ascending
    case descending
}

class ProductListViewController: UIViewController {
    // MARK: - Outlets

    var appThemeColor = ""
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var shadowView: UIView! {
        didSet {
            shadowView.applyShadow()
        }
    }

    @IBOutlet var buyNowButton: UIButton! {
        didSet {
            buyNowButton.layer.cornerRadius = 10
            buyNowButton.isEnabled = false
        }
    }

    // MARK: - Properties

    fileprivate var data: [ProductDetailsObject] = []
    fileprivate var selectedProducts: [ProductDetailsObject] = []
    fileprivate var selectedProductsDict: [String: ProductDetailsObject] = [:]
    var sortType: SortType = .ascending

    var shouldEnable: Bool = false {
        didSet {
            buyNowButton.isEnabled = shouldEnable
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialData()
        setupCollectionView()
        setupBackButton()
        setupThemedNavbar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarLargeTitleTheme(title: "Featured", color: UIColor(named: "app_theme_color") ?? UIColor.red)
        setupNavBarTitleTheme()
    }

    func setupInitialData() {
        data = ShoppingDataManager.prepareShoppingData()
        prepareSortingData()
        infoLabel.text = "\(data.count) items listed"
    }

    func prepareSortingData() {
        switch sortType {
        case .ascending:
            data.sort(by: { $0.price ?? 0.0 < $1.price ?? 0.0 })
        case .descending:
            data.sort(by: { $0.price ?? 0.0 > $1.price ?? 0.0 })
        }
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }

    @IBAction func onClickSortButton(_ sender: UIButton) {
        switch sortType {
        case .ascending:
            sortType = .descending
        case .descending:
            sortType = .ascending
        }
        prepareSortingData()
        collectionView.reloadData()
    }

    @IBAction func onClickBuyNowButton(_ sender: UIBarButtonItem) {
        let productDetailsViewController: ProductDetailsViewController = ViewControllersFactory.viewController()
        productDetailsViewController.selectedProductsDict = selectedProductsDict
        self.navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}

// MARK: UICollectionViewDataSource

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.cellIdentifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let productData = data[indexPath.item]
        if selectedProductsDict[productData.id ?? ""] != nil {
            cell.layout(basedOn: productData, isSelected: true)
        } else {
            cell.layout(basedOn: productData, isSelected: false)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let productData = data[indexPath.item]

        let id = productData.id ?? ""
        if selectedProductsDict[id] != nil {
            selectedProductsDict.removeValue(forKey: id)
        } else {
            selectedProductsDict[id] = productData
        }
        shouldEnable = selectedProductsDict.count >= 1 ? true : false
        collectionView.reloadData()
    }
}

// MARK: - Extension that adds conformance to UICollectionViewDelegateFlowLayout

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset = collectionView.contentInset
        let itemSize = (collectionView.frame.width - (contentInset.left + contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

// MARK: - Extension that adds support for PinterestLayoutDelegate protocol

extension ProductListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let productData = data[indexPath.item]
        return min(productData.image?.size.height ?? 300, 300)
    }
}
