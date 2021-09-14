//
//  ProductPaymentTableViewCell.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation
import UIKit

class ProductPaymentTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addNewCard: UIButton!
    @IBOutlet var collectionView: UICollectionView!

    lazy var centerFlowLayout: CenterFlowLayout? = {
        collectionView.collectionViewLayout as? CenterFlowLayout
    }()

    static let cellIdentifier = String(describing: ProductPaymentTableViewCell.self)

    private var cards: [CardData] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        cards = CardsDataManager.getCardsData()
        registerCells()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView?.backgroundColor = .white
        centerFlowLayout?.itemSize = CGSize(
            width: collectionView.bounds.width * 0.8,
            height: collectionView.bounds.width * 0.5
        )

        centerFlowLayout?.animationMode = CenterFlowLayoutAnimation.scale(sideItemScale: 0.6, sideItemAlpha: 0.6, sideItemShift: 0.0)

        centerFlowLayout?.spacingMode = .fixed(spacing: 20)
    }

    func registerCells() {
        collectionView.registerCell(CardCollectionViewCell.cellIdentifier)
    }
}

// MARK: UICollectionViewDataSource

extension ProductPaymentTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.cellIdentifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layout(basedOn: cards[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ProductPaymentTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cIndexPath = centerFlowLayout?.currentCenteredIndexPath,
           cIndexPath != indexPath
        {
            centerFlowLayout?.scrollToPage(atIndex: indexPath.row)
        }
    }
}
