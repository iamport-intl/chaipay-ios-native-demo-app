//
//  ShoppingDataManager.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 28/07/21.
//

import Foundation

class ShoppingDataManager {
        static func prepareShoppingData() -> [ProductDetailsObject] {
        let earRings = ProductDetailsObject(id: randomString(), title: "Ear Rings", description: "Special Design", price: 29100, currency: "₫", imageName: "icon_earrings")
        
        let scarf = ProductDetailsObject(id: randomString(), title: "Scarf", description: "Special Design", price: 15000, currency: "₫", imageName: "earRings")
        
        let bikerJacket = ProductDetailsObject(id: randomString(), title: "Biker jacket", description: "Special Design", price: 18500, currency: "₫", imageName: "Biker jacket")
        
        let bikerUnisexJacket = ProductDetailsObject(id: randomString(), title: "Biker Unisex Winter Jacket", description: "Special Design", price: 116400, currency: "₫", imageName: "Biker unisex winter jacket")
        
        let chinosPant = ProductDetailsObject(id: randomString(), title: "Chinos Pant", description: "Special Design", price: 12800, currency: "₫", imageName: "Chinos for men")
        
        let cottonReversibleJacket = ProductDetailsObject(id: randomString(), title: "Cotton Reversible Jacket", description: "Buy one, twin on", price: 171100, currency: "₫", imageName: "Cotton reversible jacket")
        
        let lightGreenTShirt = ProductDetailsObject(id: randomString(), title: "Green T-shirt", description: "Special Design", price: 12400, currency: "₫", imageName: "Light green tshirt")
        
        let menCasualsFullSleeves = ProductDetailsObject(id: randomString(), title: "Casuals Full Sleeves", description: "Special Design", price: 112000, currency: "₫", imageName: "Men casuals full sleeves")
        
        let menCasualsHalfSleeves = ProductDetailsObject(id: randomString(), title: "Casuals Half Sleeves", description: "Special Design", price: 12500, currency: "₫", imageName: "Men casuals half sleeves")
        
        let plainTShirt = ProductDetailsObject(id: randomString(), title: "Plain T-shirt", description: "Special Design", price: 17800, currency: "₫", imageName: "Plain tshirt")
        
        let slimChinosPant = ProductDetailsObject(id: randomString(), title: "Slim Chinos Pant", description: "Special Design", price: 85000, currency: "₫", imageName: "Slim chinos pant")
        
        let sportsTShirt = ProductDetailsObject(id: randomString(), title: "Sports T-shirt", description: "Special Design", price: 18900, currency: "₫", imageName: "Sports tshirt")
        
        let usPoloMenShorts = ProductDetailsObject(id: randomString(), title: "Polo Men Short", description: "Special Design", price: 75600, currency: "₫", imageName: "US polo men shorts")
        
        return [earRings, scarf, bikerJacket, usPoloMenShorts, sportsTShirt, slimChinosPant, menCasualsHalfSleeves, menCasualsFullSleeves, lightGreenTShirt, cottonReversibleJacket, plainTShirt, chinosPant, bikerUnisexJacket]
    }
    
    static func randomString(_ length: Int = 6) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}
