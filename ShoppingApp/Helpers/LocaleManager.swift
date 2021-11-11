//
//  LocaleManager.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 09/11/21.
//

import Foundation

class LocaleManager {
    static var shared = LocaleManager()
    
    let currentLocale = Locale.current as NSLocale
    
    var localisedLanguage: String {
        return (currentLocale.object(forKey: .languageCode) as? String) ?? "en"
    }
    
    var language: String {
        return "en"
    }
}
