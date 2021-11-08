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
    private static let APP_LANGUAGE = "AppLanguageCode"
    private static let APP_ENVIRONMENT = "SelectedEnvironment"
    
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
    
    static func persistMobileNumber(number: String?) {
        shared.set(number, forKey: MOBILE_NUMBER)
        shared.synchronize()
    }
    
    static var getMobileNumber: String? {
        return shared.string(forKey: MOBILE_NUMBER)
    }
    
    static func removeMobileNumber() {
        shared.removeObject(forKey: MOBILE_NUMBER)
    }
    
    static func persistAppLanguageCode(number: String) {
        shared.set(number, forKey: APP_LANGUAGE)
        shared.synchronize()
    }
    
    static var getLanguageCode: String? {
        return shared.string(forKey: APP_LANGUAGE)
    }
    
    static func persistAppLanguage(langCode: String) {
        shared.set([langCode], forKey: "AppleLanguages")
        shared.synchronize()
    }
    
    static func persistEnvironment(_ environmentObject: EnvironmentObject) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(environmentObject)
            
            // Write/Set Data
            shared.set(data, forKey: APP_ENVIRONMENT)
            shared.synchronize()
            
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    static var getSelectedEnvironment: EnvironmentObject? {
        if let data = shared.data(forKey: APP_ENVIRONMENT) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let environmentObject = try decoder.decode(EnvironmentObject.self, from: data)
                return environmentObject
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return EnvironmentDataManager.prepareEnvironmentData().first
    }
}
