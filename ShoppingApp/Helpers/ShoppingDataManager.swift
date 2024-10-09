//
//  ShoppingDataManager.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation

class ShoppingDataManager {
    static let currency = UserDefaults.getCurrency.code
    
        static func prepareShoppingData() -> [ProductDetailsObject] {
            print("currency", currency)
        let earRings = ProductDetailsObject(id: randomString(), title: "Sririri Toes", description: "Special Design", price: 1, currency: currency, imageName: "https://demo.portone.cloud/images/bella-toes.jpg")
        
        let scarf = ProductDetailsObject(id: randomString(), title: "Chikku Loafers", description: "Special Design", price: 15000, currency: currency, imageName: "https://demo.portone.cloud/images/chikku-loafers.jpg")
        
        let bikerJacket = ProductDetailsObject(id: randomString(), title: "(SRV) Sneakers", description: "Special Design", price: 18500, currency: currency, imageName: "https://demo.portone.cloud/images/banner2.jpg")
        
        let bikerUnisexJacket = ProductDetailsObject(id: randomString(), title: "Shuberry Heels", description: "Special Design", price: 116400, currency: currency, imageName: "https://demo.portone.cloud/images/ab.jpg")
        
        let chinosPant = ProductDetailsObject(id: randomString(), title: "Red Bellies", description: "Special Design", price: 12800, currency: currency, imageName: "https://demo.portone.cloud/images/red-bellies.jpg")
        
        let cottonReversibleJacket = ProductDetailsObject(id: randomString(), title: "Catwalk Flats", description: "Buy one, twin on", price: 171100, currency: currency, imageName: "https://demo.portone.cloud/images/catwalk-flats.jpg")
        
       
        
        return [earRings, scarf, bikerJacket, bikerUnisexJacket, chinosPant, cottonReversibleJacket]
    }
    
    static func randomString(_ length: Int = 6) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}
