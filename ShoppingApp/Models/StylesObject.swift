//
//  StylesObject.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/22.
//

import Foundation

public struct PaymentMethodsStyle:Codable{
    public var headerTitle: String?
    public var fontSize: Int?
    public var fontWeight: String?
    public var headerFontSize: Int?
    public var headerFontWeight: String?
    public var headerColor: String?
    public var themeColor: String?
    public var removeBorder:   Bool?
    public var walletViewStyles: WalletElementStyle?
    public var cardStyles: CardInputStyle?
    public var transactionStyles: TransactionStatusStyle?
    public var layout : Int? = 0
    
    public enum CodingKeys: String, CodingKey {
        case headerTitle = "headerTitle"
        case fontSize = "fontSize"
        case fontWeight = "fontWeight"
        case headerFontSize = "headerFontSize"
        case headerFontWeight = "headerFontWeight"
        case themeColor = "themeColor"
        case removeBorder = "removeBorder"
        case walletViewStyles = "walletViewStyles"
        case cardStyles = "cardStyles"
        case transactionStyles = "transactionStyles"
        case layout = "layout"
    }
    
    public init(headerTitle: String?, fontSize: Int?, fontWeight: String?, headerFontSize: Int?, headerFontWeight: String?, headerColor: String?, themeColor: String?, removeBorder: Bool?, walletViewStyles: WalletElementStyle?, cardStyles: CardInputStyle?, transactionStyles: TransactionStatusStyle?, layout: Int?) {
        self.headerTitle = headerTitle
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.headerFontSize = headerFontSize
        self.headerFontWeight = headerFontWeight
        self.themeColor = themeColor
        self.removeBorder = removeBorder
        self.walletViewStyles = walletViewStyles
        self.cardStyles = cardStyles
        self.transactionStyles = transactionStyles
        self.layout = layout
    }
}

extension PaymentMethodsStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        headerTitle = try container.decode(String.self, forKey: .headerTitle)
        fontSize = try container.decode(Int.self, forKey: .fontSize)
        fontWeight = try container.decode(String.self, forKey: .fontWeight)
        headerFontSize = try container.decode(Int.self, forKey: .headerFontSize)
        headerFontWeight = try container.decode(String.self, forKey: .headerFontWeight)
        themeColor = try container.decode(String.self, forKey: .themeColor)
        removeBorder = try container.decode(Bool.self, forKey: .removeBorder)
        walletViewStyles = try container.decode(WalletElementStyle.self, forKey: .walletViewStyles)
        cardStyles = try container.decode(CardInputStyle.self, forKey: .cardStyles)
        transactionStyles = try container.decode(TransactionStatusStyle.self, forKey: .transactionStyles)
        layout = try container.decode(Int.self, forKey: .layout)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(layout, forKey: .layout)
    }
}

public struct CheckoutStyle:Codable{
         public var themeColor: String?
         public var layout: Int? = 0
    
    public enum CodingKeys: String, CodingKey {
        case themeColor = "themeColor"
        case layout = "layout"
    }
    
    public init(themeColor: String?, layout: Int?) {
        self.themeColor = themeColor
        self.layout = layout
    }
}

extension CheckoutStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        themeColor = try container.decode(String.self, forKey: .themeColor)
        layout = try container.decode(Int.self, forKey: .layout)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(layout, forKey: .layout)
    }
}

public struct WalletElementStyle: Codable {
         public var themeColor: String?
         public var nameFontSize: Int?
         public var nameFontWeight: String?
         public var imageWidth: Int?
         public var imageHeight: Int?
         public var imageResizeMode: String?
         public var checkBoxHeight: Int?
         public var containerHeight: String?
         public var headerTitle: String?
         public var headerTitleFont: Int?
         public var headerTitleWeight: String?
         public var headerImage: String?
         public var headerImageWidth: Int?
         public var headerImageHeight: Int?
         public var headerImageResizeMode: String?
         public var searchPlaceHolder: String?
         public var shouldShowSearch:   Bool? = true
         public var payNowButtonCornerRadius: Int?
    
    public enum CodingKeys: String, CodingKey {
        case themeColor = "themeColor"
        case nameFontSize = "nameFontSize"
        case nameFontWeight = "nameFontWeight"
        case imageWidth = "imageWidth"
        case imageHeight = "imageHeight"
        case imageResizeMode = "imageResizeMode"
        case checkBoxHeight = "checkBoxHeight"
        case headerTitle = "headerTitle"
        case headerTitleFont = "headerTitleFont"
        case headerTitleWeight = "headerTitleWeight"
        case headerImage = "headerImage"
        case headerImageWidth = "headerImageWidth"
        case headerImageHeight = "headerImageHeight"
        case headerImageResizeMode = "headerImageResizeMode"
        case searchPlaceHolder = "searchPlaceHolder"
        case shouldShowSearch = "shouldShowSearch"
        case payNowButtonCornerRadius = "payNowButtonCornerRadius"
    }
    
    public init(themeColor: String?, nameFontSize: Int?, nameFontWeight: String?, imageWidth: Int?, imageHeight: Int?, imageResizeMode: String?, checkBoxHeight: Int?, headerTitle: String?, headerTitleFont: Int?, headerTitleWeight: String?, headerImage: String?,headerImageWidth: Int?,headerImageHeight: Int?,headerImageResizeMode: String?,searchPlaceHolder: String?, shouldShowSearch: Bool?,payNowButtonCornerRadius: Int?) {
        self.themeColor = themeColor
        self.nameFontSize = nameFontSize
        self.nameFontWeight = nameFontWeight
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.imageResizeMode = imageResizeMode
        self.checkBoxHeight = checkBoxHeight
        self.headerTitleFont = headerTitleFont
        self.headerTitleWeight = headerTitleWeight
        self.headerImage = headerImage
        self.headerImageWidth = headerImageWidth
        self.headerImageHeight = headerImageHeight
        self.headerImageResizeMode = headerImageResizeMode
        self.searchPlaceHolder = searchPlaceHolder
        self.shouldShowSearch = shouldShowSearch
        self.payNowButtonCornerRadius = payNowButtonCornerRadius
    }
}

extension WalletElementStyle {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        themeColor = try container.decode(String.self, forKey: .themeColor)
        nameFontSize = try container.decode(Int.self, forKey: .nameFontSize)
        nameFontWeight = try container.decode(String.self, forKey: .nameFontWeight)
        imageWidth = try container.decode(Int.self, forKey: .imageWidth)
        imageHeight = try container.decode(Int.self, forKey: .imageHeight)
        checkBoxHeight = try container.decode(Int.self, forKey: .checkBoxHeight)
        headerTitleFont = try container.decode(Int.self, forKey: .headerTitleFont)
        headerTitleWeight = try container.decode(String.self, forKey: .headerTitleWeight)
        headerImage = try container.decode(String.self, forKey: .headerImage)
        headerImageWidth = try container.decode(Int.self, forKey: .headerImageWidth)
        headerImageHeight = try container.decode(Int.self, forKey: .headerImageHeight)
        headerImageResizeMode = try container.decode(String.self, forKey: .headerImageResizeMode)
        searchPlaceHolder = try container.decode(String.self, forKey: .searchPlaceHolder)
        shouldShowSearch = try container.decode(Bool.self, forKey: .shouldShowSearch)
        payNowButtonCornerRadius = try container.decode(Int.self, forKey: .payNowButtonCornerRadius)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(nameFontSize, forKey: .nameFontSize)
        try container.encode(nameFontWeight, forKey: .nameFontWeight)
        try container.encode(imageWidth, forKey: .imageWidth)
        try container.encode(imageHeight, forKey: .imageHeight)
        try container.encode(checkBoxHeight, forKey: .checkBoxHeight)
        try container.encode(headerTitleFont, forKey: .headerTitleFont)
        try container.encode(headerTitleWeight, forKey: .headerTitleWeight)
        try container.encode(headerImage, forKey: .headerImage)
        try container.encode(headerImageWidth, forKey: .headerImageWidth)
        try container.encode(headerImageHeight, forKey: .headerImageHeight)
        try container.encode(headerImageResizeMode, forKey: .headerImageResizeMode)
        try container.encode(searchPlaceHolder, forKey: .searchPlaceHolder)
        try container.encode(shouldShowSearch, forKey: .shouldShowSearch)
        try container.encode(payNowButtonCornerRadius, forKey: .payNowButtonCornerRadius)
    }
}

public struct CardInputStyle: Codable {
         public var headerFontWeight: String?
         public var fontSize: Int?
         public var fontWeight: String?
         public var themeColor: String?
         public var showSaveForLater:   Bool?
         public var borderRadius: Int?
         public var nameFontSize: Int?
         public var payNowButtonText:String?
         public var nameFontWeight: String?
         public var buttonBorderRadius: Int?
    
    public enum CodingKeys: String, CodingKey {
        case headerFontWeight = "headerFontWeight"
        case fontSize = "fontSize"
        case fontWeight = "fontWeight"
        case themeColor = "themeColor"
        case showSaveForLater = "showSaveForLater"
        case borderRadius = "borderRadius"
        case nameFontSize = "nameFontSize"
        case payNowButtonText = "payNowButtonText"
        case nameFontWeight = "nameFontWeight"
        case buttonBorderRadius = "buttonBorderRadius"
    }
    
    public init(headerFontWeight: String?, fontSize: Int?, fontWeight: String?,showSaveForLater: Bool?,themeColor: String?,borderRadius: Int?,nameFontSize: Int?,payNowButtonText: String?,nameFontWeight: String?,buttonBorderRadius: Int?) {
        self.headerFontWeight = headerFontWeight
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.themeColor = themeColor
        self.showSaveForLater = showSaveForLater
        self.borderRadius = borderRadius
        self.nameFontSize = nameFontSize
        self.payNowButtonText = payNowButtonText
        self.nameFontWeight = nameFontWeight
        self.buttonBorderRadius = buttonBorderRadius
    }
}

extension CardInputStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        headerFontWeight = try container.decode(String.self, forKey: .headerFontWeight)
        fontSize = try container.decode(Int.self, forKey: .fontSize)
        fontWeight = try container.decode(String.self, forKey: .fontWeight)
        buttonBorderRadius = try container.decode(Int.self, forKey: .buttonBorderRadius)
        themeColor = try container.decode(String.self, forKey: .themeColor)
        showSaveForLater = try container.decode(Bool.self, forKey: .showSaveForLater)
        payNowButtonText = try container.decode(String.self, forKey: .payNowButtonText)
        borderRadius = try container.decode(Int.self, forKey: .borderRadius)
        nameFontWeight = try container.decode(String.self, forKey: .nameFontWeight)
        nameFontSize = try container.decode(Int.self, forKey: .nameFontSize)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(headerFontWeight, forKey: .headerFontWeight)
        try container.encode(fontWeight, forKey: .fontWeight)
        try container.encode(buttonBorderRadius, forKey: .buttonBorderRadius)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(showSaveForLater, forKey: .showSaveForLater)
        try container.encode(payNowButtonText, forKey: .payNowButtonText)
        try container.encode(borderRadius, forKey: .borderRadius)
        try container.encode(nameFontWeight, forKey: .nameFontWeight)
        try container.encode(nameFontSize, forKey: .nameFontSize)
    }
}

public struct SavedCardsStyle: Codable{
         public var showAuthenticationFlow:   Bool?
         public var showSheet:   Bool?
         public var checkBoxColor: String?
         public var checkBoxSelectionColor: String?
         public var themeColor: String?
         public var checkBoxHeight: Int?
         public var nameFontSize: Int?
         public var nameFontWeight: String?
         public var subNameFontSize: Int?
         public var subNameFontWeight: String?
         public var imageWidth: Int?
         public var imageHeight: Int?
         public var imageResizeMode: String?
         public var containerHorizontalPadding: Int?
         public var containerVerticalPadding: Int?
         public var headerTitle: String?
         public var headerTitleFont: Int?
         public var headerTitleWeight: String?
         public var headerImageWidth: Int?
         public var headerImageHeight: Int?
         public var headerImageResizeMode: String?
         public var backgroundColor:String?
         public var layout: Int? = 0
    
    
    public enum CodingKeys: String, CodingKey {
        case showAuthenticationFlow  = "showAuthenticationFlow"
        case showSheet  = "showSheet"
        case checkBoxColor  = "checkBoxColor"
        case checkBoxSelectionColor  = "checkBoxSelectionColor"
        case themeColor  = "themeColor"
        case checkBoxHeight  = "checkBoxHeight"
        case nameFontSize  = "nameFontSize"
        case nameFontWeight  = "nameFontWeight"
        case subNameFontSize  = "subNameFontSize"
        case subNameFontWeight  = "subNameFontWeight"
        case imageWidth  = "imageWidth"
        case imageHeight  = "imageHeight"
        case imageResizeMode  = "imageResizeMode"
        case containerHorizontalPadding  = "containerHorizontalPadding"
        case containerVerticalPadding  = "containerVerticalPadding"
        case headerTitle  = "headerTitle"
        case headerTitleFont  = "headerTitleFont"
        case headerTitleWeight  = "headerTitleWeight"
        case headerImageWidth  = "headerImageWidth"
        case headerImageHeight  = "headerImageHeight"
        case headerImageResizeMode  = "headerImageResizeMode"
        case backgroundColor  = "backgroundColor"
        case layout = "layout"
    }
    
    public init(showAuthenticationFlow: Bool?,
                          showSheet: Bool?,
                          checkBoxColor: String?,
                          checkBoxSelectionColor: String?,
                          themeColor: String?,
                          checkBoxHeight: Int?,
                          nameFontSize: Int?,
                          nameFontWeight: String?,
                          subNameFontSize: Int?,
                          subNameFontWeight: String?,
                          imageWidth: Int?,
                          imageHeight: Int?,
                          imageResizeMode: String?,
                          containerHorizontalPadding:Int?,
                          containerVerticalPadding:Int?,
                          headerTitle: String?,
                          headerTitleFont: Int?,
                          headerTitleWeight: String?,
                          headerImageWidth: Int?,
                          headerImageHeight: Int?,
                          headerImageResizeMode: String?,
                          backgroundColor: String?,
                          layout: Int?) {
        self.showAuthenticationFlow  = showAuthenticationFlow
        self.showSheet  = showSheet
        self.checkBoxColor  = checkBoxColor
        self.checkBoxSelectionColor  = checkBoxSelectionColor
        self.themeColor  = themeColor
        self.checkBoxHeight  = checkBoxHeight
        self.nameFontSize  = nameFontSize
        self.nameFontWeight  = nameFontWeight
        self.subNameFontSize  = subNameFontSize
        self.subNameFontWeight  = subNameFontWeight
        self.imageWidth  = imageWidth
        self.imageHeight  = imageHeight
        self.imageResizeMode  = imageResizeMode
        self.containerHorizontalPadding  = containerHorizontalPadding
        self.containerVerticalPadding  = containerVerticalPadding
        self.headerTitle  = headerTitle
        self.headerTitleFont  = headerTitleFont
        self.headerTitleWeight  = headerTitleWeight
        self.headerImageWidth  = headerImageWidth
        self.headerImageHeight  = headerImageHeight
        self.headerImageResizeMode  = headerImageResizeMode
        self.backgroundColor  = backgroundColor
        self.layout = layout
    }
}

extension SavedCardsStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        showAuthenticationFlow  = try container.decode(Bool.self, forKey: .showAuthenticationFlow)
        showSheet  = try container.decode(Bool.self, forKey: .showSheet)
        checkBoxColor  = try container.decode(String.self, forKey: .checkBoxColor)
        checkBoxSelectionColor  = try container.decode(String.self, forKey: .checkBoxSelectionColor)
        themeColor  = try container.decode(String.self, forKey: .themeColor)
        checkBoxHeight  = try container.decode(Int.self, forKey: .checkBoxHeight)
        nameFontSize  = try container.decode(Int.self, forKey: .nameFontSize)
        nameFontWeight  = try container.decode(String.self, forKey: .nameFontWeight)
        subNameFontSize  = try container.decode(Int.self, forKey: .subNameFontSize)
        subNameFontWeight  = try container.decode(String.self, forKey: .subNameFontWeight)
        imageWidth  = try container.decode(Int.self, forKey: .imageWidth)
        imageHeight  = try container.decode(Int.self, forKey: .imageHeight)
        imageResizeMode  = try container.decode(String.self, forKey: .imageResizeMode)
        containerHorizontalPadding  = try container.decode(Int.self, forKey: .containerHorizontalPadding)
        containerVerticalPadding  = try container.decode(Int.self, forKey: .containerVerticalPadding)
        headerTitle  = try container.decode(String.self, forKey: .headerTitle)
        headerTitleFont  = try container.decode(Int.self, forKey: .headerTitleFont)
        headerTitleWeight  = try container.decode(String.self, forKey: .headerTitleWeight)
        headerImageWidth  = try container.decode(Int.self, forKey: .headerImageWidth)
        headerImageHeight  = try container.decode(Int.self, forKey: .headerImageHeight)
        headerImageResizeMode  = try container.decode(String.self, forKey: .headerImageResizeMode)
        backgroundColor  = try container.decode(String.self, forKey: .backgroundColor)
        layout = try container.decode(Int.self, forKey: .layout)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(showAuthenticationFlow, forKey: .showAuthenticationFlow)
        try container.encode(showSheet, forKey: .showSheet)
        try container.encode(checkBoxColor, forKey: .checkBoxColor)
        try container.encode(checkBoxSelectionColor, forKey: .checkBoxSelectionColor)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(checkBoxHeight, forKey: .checkBoxHeight)
        try container.encode(nameFontSize, forKey: .nameFontSize)
        try container.encode(nameFontWeight, forKey: .nameFontWeight)
        try container.encode(subNameFontSize, forKey: .subNameFontSize)
        try container.encode(subNameFontWeight, forKey: .subNameFontWeight)
        try container.encode(imageWidth, forKey: .imageWidth)
        try container.encode(imageHeight, forKey: .imageHeight)
        try container.encode(imageResizeMode, forKey: .imageResizeMode)
        try container.encode(containerHorizontalPadding, forKey: .containerHorizontalPadding)
        try container.encode(containerVerticalPadding, forKey: .containerVerticalPadding)
        try container.encode(headerTitle, forKey: .headerTitle)
        try container.encode(headerTitleFont, forKey: .headerTitleFont)
        try container.encode(headerTitleWeight, forKey: .headerTitleWeight)
        try container.encode(headerImageWidth, forKey: .headerImageWidth)
        try container.encode(headerImageHeight, forKey: .headerImageHeight)
        try container.encode(headerImageResizeMode, forKey: .headerImageResizeMode)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(layout, forKey: .layout)
    }
}

public struct PayNowStyle: Codable {
         public var themeColor: String?
         public var textFontSize: Int?
         public var textFontWeight: String?
         public var textColor: String?
         public var borderRadius: Int?
         public var height: Int?
         public var width: Int?
         public var text: String?
    
    public enum CodingKeys: String, CodingKey {
        case themeColor = "themeColor"
        case textFontSize = "textFontSize"
        case textFontWeight = "textFontWeight"
        case textColor = "textColor"
        case borderRadius = "borderRadius"
        case height = "height"
        case width = "width"
        case text = "text"
    }
    
    public init(themeColor: String?,
                textFontSize: Int?,
                textFontWeight: String?,
                textColor: String?,
                borderRadius: Int?,
                height: Int?,
                width: Int?,
                text: String?) {
        self.themeColor = themeColor
        self.textFontSize = textFontSize
        self.textFontWeight = textFontWeight
        self.textColor = textColor
        self.borderRadius = borderRadius
        self.height = height
        self.width = width
        self.text = text
    }
    }

extension PayNowStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        themeColor = try container.decode(String.self, forKey: .themeColor)
        textFontSize = try container.decode(Int.self, forKey: .textFontSize)
        textFontWeight = try container.decode(String.self, forKey: .textFontWeight)
        textColor = try container.decode(String.self, forKey: .textColor)
        borderRadius = try container.decode(Int.self, forKey: .borderRadius)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        text = try container.decode(String.self, forKey: .text)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(textFontSize, forKey: .textFontSize)
        try container.encode(textFontWeight, forKey: .textFontWeight)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(borderRadius, forKey: .borderRadius)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try container.encode(text, forKey: .text)
    }
}

public struct CartStyle: Codable {
         public var height: Int?
         public var nameFontSize: Int?
         public var nameFontWeight: String?
         public var descriptionSize: Int?
         public var descriptionFontWeight: String?
         public var amountTitle: String?
         public var amountFont: Int?
         public var amountFontWeight: String?
         public var deliveryTitle: String?
         public var deliveryFont: Int?
         public var deliveryFontWeight: String?
         public var summaryTitle: String?
         public var summaryFont: Int?
         public var summaryFontWeight: String?
         public var borderRadius: Int?
         public var borderWidth: Int?
         public var headerText: String?
         public var orderSummaryText: String?
         public var headerTextColor: String?
         public var headerFont: Int?
         public var headerFontWeight: String?
         public var removeBorder:   Bool?
         public var showNetPayable:   Bool?
         public var borderColor: String?
         public var themeColor: String?
         public var deliveryColor: String?
         public var summaryColor: String?
         public var amountColor: String?
         public var backgroundColor : String?
         public var layout: Int? = 0
    
    
    public enum CodingKeys: String, CodingKey {
        case height = "height"
        case nameFontSize = "nameFontSize"
        case nameFontWeight = "nameFontWeight"
        case descriptionSize = "descriptionSize"
        case descriptionFontWeight = "descriptionFontWeight"
        case amountTitle = "amountTitle"
        case amountFont = "amountFont"
        case amountFontWeight = "amountFontWeight"
        case deliveryTitle = "deliveryTitle"
        case deliveryFont = "deliveryFont"
        case deliveryFontWeight = "deliveryFontWeight"
        case summaryTitle = "summaryTitle"
        case summaryFont = "summaryFont"
        case summaryFontWeight = "summaryFontWeight"
        case borderRadius = "borderRadius"
        case borderWidth = "borderWidth"
        case headerText = "headerText"
        case orderSummaryText = "orderSummaryText"
        case headerTextColor = "headerTextColor"
        case headerFont = "headerFont"
        case headerFontWeight = "headerFontWeight"
        case removeBorder = "removeBorder"
        case showNetPayable = "showNetPayable"
        case borderColor = "borderColor"
        case themeColor = "themeColor"
        case deliveryColor = "deliveryColor"
        case summaryColor = "summaryColor"
        case amountColor = "amountColor"
        case backgroundColor = "backgroundColor"
        case layout = "layout"
    }
    
    public init(height: Int?,
                nameFontSize: Int?,
                nameFontWeight: String?,
                descriptionSize: Int?,
                descriptionFontWeight: String?,
                amountTitle: String?,
                amountFont: Int?,
                amountFontWeight: String?,
                deliveryTitle: String?,
                deliveryFont: Int?,
                deliveryFontWeight: String?,
                summaryTitle: String?,
                summaryFont: Int?,
                summaryFontWeight: String?,
                borderRadius: Int?,
                borderWidth: Int?,
                headerText: String?,
                orderSummaryText: String?,
                headerTextColor: String?,
                headerFont: Int?,
                headerFontWeight: String?,
                removeBorder:   Bool?,
                showNetPayable:   Bool?,
                borderColor: String?,
                themeColor: String?,
                deliveryColor: String?,
                summaryColor: String?,
                amountColor: String?,
                backgroundColor : String?,
                layout: Int? = 0) {
        self.height = height
        self.nameFontSize = nameFontSize
        self.nameFontWeight = nameFontWeight
        self.descriptionSize = descriptionSize
        self.descriptionFontWeight = descriptionFontWeight
        self.amountTitle = amountTitle
        self.amountFont = amountFont
        self.amountFontWeight = amountFontWeight
        self.deliveryTitle = deliveryTitle
        self.deliveryFont = deliveryFont
        self.deliveryFontWeight = deliveryFontWeight
        self.summaryTitle = summaryTitle
        self.summaryFont = summaryFont
        self.summaryFontWeight = summaryFontWeight
        self.borderRadius = borderRadius
        self.borderWidth = borderWidth
        self.headerText = headerText
        self.orderSummaryText = orderSummaryText
        self.headerTextColor = headerTextColor
        self.headerFont = headerFont
        self.headerFontWeight = headerFontWeight
        self.removeBorder = removeBorder
        self.showNetPayable = showNetPayable
        self.borderColor = borderColor
        self.themeColor = themeColor
        self.deliveryColor = deliveryColor
        self.summaryColor = summaryColor
        self.amountColor = amountColor
        self.backgroundColor = backgroundColor
        self.layout = layout
    }
}

extension CartStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        height = try container.decode(Int.self, forKey:  .height)
        nameFontSize = try container.decode(Int.self, forKey:  .nameFontSize)
        nameFontWeight = try container.decode(String.self, forKey:  .nameFontWeight)
        descriptionSize = try container.decode(Int.self, forKey:  .descriptionSize)
        descriptionFontWeight = try container.decode(String.self, forKey:  .descriptionFontWeight)
        amountTitle = try container.decode(String.self, forKey:  .amountTitle)
        amountFont = try container.decode(Int.self, forKey:  .amountFont)
        amountFontWeight = try container.decode(String.self, forKey:  .amountFontWeight)
        deliveryTitle = try container.decode(String.self, forKey:  .deliveryTitle)
        deliveryFont = try container.decode(Int.self, forKey:  .deliveryFont)
        deliveryFontWeight = try container.decode(String.self, forKey:  .deliveryFontWeight)
        summaryTitle = try container.decode(String.self, forKey:  .summaryTitle)
        summaryFont = try container.decode(Int.self, forKey:  .summaryFont)
        summaryFontWeight = try container.decode(String.self, forKey:  .summaryFontWeight)
        borderRadius = try container.decode(Int.self, forKey:  .borderRadius)
        borderWidth = try container.decode(Int.self, forKey:  .borderWidth)
        headerText = try container.decode(String.self, forKey:  .headerText)
        orderSummaryText = try container.decode(String.self, forKey:  .orderSummaryText)
        headerTextColor = try container.decode(String.self, forKey:  .headerTextColor)
        headerFont = try container.decode(Int.self, forKey:  .headerFont)
        headerFontWeight = try container.decode(String.self, forKey:  .headerFontWeight)
        removeBorder = try container.decode(Bool.self, forKey:  .removeBorder)
        showNetPayable = try container.decode(Bool.self, forKey:  .showNetPayable)
        borderColor = try container.decode(String.self, forKey:  .borderColor)
        themeColor = try container.decode(String.self, forKey:  .themeColor)
        deliveryColor = try container.decode(String.self, forKey:  .deliveryColor)
        summaryColor = try container.decode(String.self, forKey:  .summaryColor)
        amountColor = try container.decode(String.self, forKey:  .amountColor)
        backgroundColor = try container.decode(String.self, forKey:  .backgroundColor)
        layout = try container.decode(Int.self, forKey:  .layout)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(height, forKey:  .height)
        try container.encode(nameFontSize, forKey:  .nameFontSize)
        try container.encode(nameFontWeight, forKey:  .nameFontWeight)
        try container.encode(descriptionSize, forKey:  .descriptionSize)
        try container.encode(descriptionFontWeight, forKey:  .descriptionFontWeight)
        try container.encode(amountTitle, forKey:  .amountTitle)
        try container.encode(amountFont, forKey:  .amountFont)
        try container.encode(amountFontWeight, forKey:  .amountFontWeight)
        try container.encode(deliveryTitle, forKey:  .deliveryTitle)
        try container.encode(deliveryFont, forKey:  .deliveryFont)
        try container.encode(deliveryFontWeight, forKey:  .deliveryFontWeight)
        try container.encode(summaryTitle, forKey:  .summaryTitle)
        try container.encode(summaryFont, forKey:  .summaryFont)
        try container.encode(summaryFontWeight, forKey:  .summaryFontWeight)
        try container.encode(borderRadius, forKey:  .borderRadius)
        try container.encode(borderWidth, forKey:  .borderWidth)
        try container.encode(headerText, forKey:  .headerText)
        try container.encode(orderSummaryText, forKey:  .orderSummaryText)
        try container.encode(headerTextColor, forKey:  .headerTextColor)
        try container.encode(headerFont, forKey:  .headerFont)
        try container.encode(headerFontWeight, forKey:  .headerFontWeight)
        try container.encode(removeBorder, forKey:  .removeBorder)
        try container.encode(showNetPayable, forKey:  .showNetPayable)
        try container.encode(borderColor, forKey:  .borderColor)
        try container.encode(themeColor, forKey:  .themeColor)
        try container.encode(deliveryColor, forKey:  .deliveryColor)
        try container.encode(summaryColor, forKey:  .summaryColor)
        try container.encode(amountColor, forKey:  .amountColor)
        try container.encode(backgroundColor, forKey:  .backgroundColor)
        try container.encode(layout, forKey:  .layout)
                 
    }
}

public struct SummaryStyle: Codable {
         public var hideHeaderView: Bool?
         public var removeBorder:   Bool?
         public var amountTitle: String?
         public var amountFont: Int?
         public var amountColor: String?
         public var amountFontWeight: String?
         public var deliveryTitle: String?
         public var deliveryFont: Int?
         public var deliveryColor: String?
         public var deliveryFontWeight: String?
         public var summaryTitle: String?
         public var summaryFont: Int?
         public var summaryColor: String?
         public var summaryFontWeight: String?
         public var backgroundColor: String?
    
    public enum CodingKeys: String, CodingKey {
        case hideHeaderView = "hideHeaderView"
        case removeBorder = "removeBorder"
        case amountTitle = "amountTitle"
        case amountFont = "amountFont"
        case amountColor = "amountColor"
        case amountFontWeight = "amountFontWeight"
        case deliveryTitle = "deliveryTitle"
        case deliveryFont = "deliveryFont"
        case deliveryColor = "deliveryColor"
        case deliveryFontWeight = "deliveryFontWeight"
        case summaryTitle = "summaryTitle"
        case summaryFont = "summaryFont"
        case summaryColor = "summaryColor"
        case summaryFontWeight = "summaryFontWeight"
        case backgroundColor = "backgroundColor"
    }
    
    public init(hideHeaderView: Bool?,
                removeBorder:   Bool?,
                amountTitle: String?,
                amountFont: Int?,
                amountColor: String?,
                amountFontWeight: String?,
                deliveryTitle: String?,
                deliveryFont: Int?,
                deliveryColor: String?,
                deliveryFontWeight: String?,
                summaryTitle: String?,
                summaryFont: Int?,
                summaryColor: String?,
                summaryFontWeight: String?,
                backgroundColor: String?) {
        self.hideHeaderView = hideHeaderView
                 self.removeBorder = removeBorder
                 self.amountTitle = amountTitle
                 self.amountFont = amountFont
                 self.amountColor = amountColor
                 self.amountFontWeight = amountFontWeight
                 self.deliveryTitle = deliveryTitle
                 self.deliveryFont = deliveryFont
                 self.deliveryColor = deliveryColor
                 self.deliveryFontWeight = deliveryFontWeight
                 self.summaryTitle = summaryTitle
                 self.summaryFont = summaryFont
                 self.summaryColor = summaryColor
                 self.summaryFontWeight = summaryFontWeight
                 self.backgroundColor = backgroundColor
    }
}
extension SummaryStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hideHeaderView = try container.decode(Bool.self, forKey: .hideHeaderView)
        removeBorder = try container.decode(Bool.self, forKey: .removeBorder)
        amountTitle = try container.decode(String.self, forKey: .amountTitle)
        amountFont = try container.decode(Int.self, forKey: .amountFont)
        amountColor = try container.decode(String.self, forKey: .amountColor)
        amountFontWeight = try container.decode(String.self, forKey: .amountFontWeight)
        deliveryTitle = try container.decode(String.self, forKey: .deliveryTitle)
        deliveryFont = try container.decode(Int.self, forKey: .deliveryFont)
        deliveryColor = try container.decode(String.self, forKey: .deliveryColor)
        deliveryFontWeight = try container.decode(String.self, forKey: .deliveryFontWeight)
        summaryTitle = try container.decode(String.self, forKey: .summaryTitle)
        summaryFont = try container.decode(Int.self, forKey: .summaryFont)
        summaryColor = try container.decode(String.self, forKey: .summaryColor)
        summaryFontWeight = try container.decode(String.self, forKey: .summaryFontWeight)
        backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hideHeaderView, forKey: .hideHeaderView)
        try container.encode(removeBorder, forKey: .removeBorder)
        try container.encode(amountTitle, forKey: .amountTitle)
        try container.encode(amountFont, forKey: .amountFont)
        try container.encode(amountColor, forKey: .amountColor)
        try container.encode(amountFontWeight, forKey: .amountFontWeight)
        try container.encode(deliveryTitle, forKey: .deliveryTitle)
        try container.encode(deliveryFont, forKey: .deliveryFont)
        try container.encode(deliveryColor, forKey: .deliveryColor)
        try container.encode(deliveryFontWeight, forKey: .deliveryFontWeight)
        try container.encode(summaryTitle, forKey: .summaryTitle)
        try container.encode(summaryFont, forKey: .summaryFont)
        try container.encode(summaryColor, forKey: .summaryColor)
        try container.encode(summaryFontWeight, forKey: .summaryFontWeight)
        try container.encode(backgroundColor, forKey: .backgroundColor)
    }
}

public struct TransactionStatusStyle : Codable{
         public var themeColor: String?
         public var backgroundColor: String?
         public var borderRadius: Int?
         public var nameFontSize: Int?
         public var nameFontWeight: String?   
         public var buttonBorderRadius: Int?
    
    public enum CodingKeys: String, CodingKey {
        case themeColor = "themeColor"
        case backgroundColor = "backgroundColor"
        case borderRadius = "borderRadius"
        case nameFontSize = "nameFontSize"
        case nameFontWeight = "nameFontWeight"
        case buttonBorderRadius = "buttonBorderRadius"
    }
    
    public init(themeColor: String?,
                backgroundColor: String?,
                borderRadius: Int?,
                nameFontSize: Int?,
                nameFontWeight: String?   ,
                buttonBorderRadius: Int?) {
        self.themeColor = themeColor
        self.backgroundColor = backgroundColor
        self.borderRadius = borderRadius
        self.nameFontSize = nameFontSize
        self.nameFontWeight = nameFontWeight
        self.buttonBorderRadius = buttonBorderRadius
    }
}

extension TransactionStatusStyle {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        themeColor = try container.decode(String.self, forKey: .themeColor)
        backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
        borderRadius = try container.decode(Int.self, forKey: .borderRadius)
        nameFontSize = try container.decode(Int.self, forKey: .nameFontSize)
        nameFontWeight = try container.decode(String.self, forKey: .nameFontWeight)
        buttonBorderRadius = try container.decode(Int.self, forKey: .buttonBorderRadius)

    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(themeColor, forKey: .themeColor)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(borderRadius, forKey: .borderRadius)
        try container.encode(nameFontSize, forKey: .nameFontSize)
        try container.encode(nameFontWeight, forKey: .nameFontWeight)
        try container.encode(buttonBorderRadius, forKey: .buttonBorderRadius)
    }
}
