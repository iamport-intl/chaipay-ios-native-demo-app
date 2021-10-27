//
//  UserDefaults.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 26/10/21.
//

import Foundation

class UserDefaults {
    
    static let shared = Foundation.UserDefaults.standard
    
    private static let AUTHORISATION_TOKEN = "token"
    private static let MOBILE_NUMBER = "mobileNumber"
    
    static func persist(token: String) {
        shared.set(token, forKey: AUTHORISATION_TOKEN)
        shared.synchronize()
    }
    
    static var getAuthorisationToken: String? {
        return shared.string(forKey: AUTHORISATION_TOKEN)
    }
    
    static func removeAuthorisationToken() {
        shared.removeObject(forKey: AUTHORISATION_TOKEN)
    }
    
    static func persistMobileNumber(number: String? = "+918341469169") {
        shared.set(number, forKey: MOBILE_NUMBER)
        shared.synchronize()
    }
    
    static var getMobileNumber: String? {
        return shared.string(forKey: MOBILE_NUMBER)
    }
}
