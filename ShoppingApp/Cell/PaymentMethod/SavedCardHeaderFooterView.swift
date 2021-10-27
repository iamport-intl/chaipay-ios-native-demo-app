//
//  SavedCardHeaderFooterView.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 22/10/21.
//

import UIKit

enum SectionHeaderViewType {
    case myCart
    case savedCards
}

protocol SavedCardHeaderFooterViewDelegate: AnyObject {
    func onClickSavedCard(_ isExpanded: Bool, _ viewType: SectionHeaderViewType)
}

class SavedCardHeaderFooterView: UITableViewHeaderFooterView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleView: UIView!
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: "icon_collapse")
        }
    }
    @IBOutlet var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var bottomSpaceConstraint: NSLayoutConstraint!
    
    private var viewType: SectionHeaderViewType = .myCart
    private var isExpanded: Bool = false
    weak var delegate: SavedCardHeaderFooterViewDelegate?
    static let cellIdentifier = String(describing: SavedCardHeaderFooterView.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onClickSavedCard() {
        isExpanded = !isExpanded
        delegate?.onClickSavedCard(isExpanded, viewType)
    }
}

extension SavedCardHeaderFooterView {
    func layout(basedOn title: String, viewType: SectionHeaderViewType, isExpanded: Bool) {
        self.viewType = viewType
        self.isExpanded = isExpanded
        imageView.image = isExpanded ?  UIImage(named: "icon_expand") : UIImage(named: "icon_collapse")
        titleLabel.text = title
        switch viewType {
        case .myCart:
            topSpaceConstraint.constant = 0
            bottomSpaceConstraint.constant = 0
            self.contentView.backgroundColor = .white
        case .savedCards:
            topSpaceConstraint.constant = 8
            bottomSpaceConstraint.constant = 8
            self.contentView.backgroundColor = .systemGray6
        }
    }
}
