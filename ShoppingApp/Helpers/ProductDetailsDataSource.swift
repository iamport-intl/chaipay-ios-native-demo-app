//
//  ProductDetailsDataSource.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation
import UIKit

enum DetailsSectionType {
    case details
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

    var datasource: [ProductDetailsObject] = []

    var rowCount: Int {
        return datasource.count
    }

    var rowHeight: CGFloat {
        return UITableView.automaticDimension
    }

    init(datasource: [ProductDetailsObject]) {
        self.datasource = datasource
    }
}

class ProductPaymentDataModel: DetailsSectionItem {
    var type: DetailsSectionType {
        return .payment
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
