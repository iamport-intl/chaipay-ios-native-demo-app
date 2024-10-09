//
//  ProductDetailsDataSource.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation
import UIKit
import PortoneSDK

enum DetailsSectionType {
    case details
    case savedCards
    case payment
    case summary
}

protocol DetailsSectionItem {
    var sectionTitle: String? { get }
    var headerHeight: CGFloat { get }
    var rowHeight: CGFloat { get }
    var footerHeight: CGFloat { get }
    var rowCount: Int { get }
    var type: DetailsSectionType { get }
}

extension DetailsSectionItem {
    var rowCount: Int {
        return 1
    }

    var headerHeight: CGFloat {
        return 0.01
    }

    var footerHeight: CGFloat {
        return 0.01
    }

    var rowHeight: CGFloat {
        return UITableView.automaticDimension
    }

    var sectionTitle: String? {
        return nil
    }
}

class ProductDetailsDataModel: DetailsSectionItem {
    var type: DetailsSectionType {
        return .details
    }

    let datasource: [ProductDetailsObject]
    let isExpanded: Bool

    var rowCount: Int {
        return isExpanded ? datasource.count : 0
    }

    var rowHeight: CGFloat {
        return UITableView.automaticDimension
    }

    init(datasource: [ProductDetailsObject], isExpanded: Bool) {
        self.datasource = datasource
        self.isExpanded = isExpanded
    }
    
    var sectionTitle: String? {
        return "my_cart".localized
    }
    
    var headerHeight: CGFloat {
        return UITableView.automaticDimension
    }
}

class SavedCardsPaymentDataModel: DetailsSectionItem {
    
    var type: DetailsSectionType {
        return .savedCards
    }

    let datasource: [SavedCard]?
    let shouldShowOTPInputView: Bool
    let mobileNumberVerified: Bool
    let isExpand: Bool

    var rowCount: Int {
        if isExpand {
            if mobileNumberVerified {
                return datasource!.count == 0 ? 1 : 1
            } else {
                return 1
            }
        } else {
            return 0
        }
    }

    var rowHeight: CGFloat {
        return UITableView.automaticDimension
    }

    init(datasource: [SavedCard], shouldShowOTPInputView: Bool, mobileNumberVerified: Bool, isExpand: Bool) {
        self.datasource = datasource
        self.shouldShowOTPInputView = shouldShowOTPInputView
        self.mobileNumberVerified = mobileNumberVerified
        self.isExpand = isExpand
    }
    
    var sectionTitle: String? {
        return "saved_cards".localized
    }
    
    var headerHeight: CGFloat {
        return UITableView.automaticDimension
    }
}

class ProductPaymentDataModel: DetailsSectionItem {
    
    var type: DetailsSectionType {
        return .payment
    }

    var dataSource: [PaymentMethodDataSource] = []

    var rowCount: Int {
        return dataSource.count
    }

    var rowHeight: CGFloat {
        return UITableView.automaticDimension
    }
    
    var sectionTitle: String? {
        return "other_options".localized
    }
    
    var headerHeight: CGFloat {
        return 40
    }

    init(dataSource: [PaymentMethodDataSource]) {
        self.dataSource = dataSource
    }
}

class ProductSummaryDataModel: DetailsSectionItem {
    var type: DetailsSectionType {
        return .summary
    }

    var summaryObject: SummaryObject?

    init(summaryObject: SummaryObject) {
        self.summaryObject = summaryObject
    }
}

class ProductDetailsDataSource {
    var items: [DetailsSectionItem] = []
}
