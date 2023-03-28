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
    private static let THEME_COLOR = "ThemeColorCode"
    private static let APP_ENVIRONMENT = "SelectedEnvironment"
    private static let LAYOUT = "Layout"
    
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
    
    static func persistAppLanguageCode(language: Language) {
        shared.set(language.rawValue, forKey: APP_LANGUAGE)
        shared.synchronize()
    }
    
    static var getLanguage: Language {
        guard let language = shared.string(forKey: APP_LANGUAGE) else {
            return .english
        }
        return Language(rawValue: language) ?? .english
    }
    
    static func persistAppCurrencyCode(language: Currency) {

        
        shared.set(language.rawValue, forKey: "Currency")
        shared.synchronize()
    }
    
    static var getCurrency: Currency {
        guard let language = shared.string(forKey: "Currency") else {
            return .english
        }
        return Currency(rawValue: language) ?? .english
    }
    static func persistAppThemeColorCode(color: ThemeColor) {
        shared.set(color.rawValue, forKey: THEME_COLOR)
        shared.synchronize()
    }
    
    static var getThemeColor: ThemeColor {
        guard let language = shared.string(forKey: THEME_COLOR) else {
            return .red
        }
        return ThemeColor(rawValue: language) ?? .red
    }
    
    static func persistLayoutCode(layout: Layout) {
        shared.set(layout.rawValue, forKey: LAYOUT)
        shared.synchronize()
    }
    
    static var getLayout: Layout {
        guard let language = shared.string(forKey: LAYOUT) else {
            return .one
        }
        return Layout(rawValue: language) ?? .one
    }
    
    static func persistAppLanguage(langCode: String) {
        shared.set([langCode], forKey: "AppleLanguages")
        shared.synchronize()
    }
    
    static func persistChaipayKey(key: String) {
        shared.set(key, forKey: "ChaipayKey")
        shared.synchronize()
    }
    
    static func persistSecretKey(key: String) {
        shared.set(key, forKey: "SecretKey")
        shared.synchronize()
    }
    
    static func persistEnv(environmentObject: EnvObject) {
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(environmentObject)
            
            // Write/Set Data
            shared.set(data, forKey: "env")
            shared.synchronize()
            
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        
    }
    
    static func persistDevEnv(envObj: DevEnvObject) {
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(envObj)
            shared.set(data, forKey: "devENV")
            shared.synchronize()
        }
        catch {
            print("Unable to encode (\(error))")
        }
    }
    
    
    static var getChaipayKey: String? {
        return shared.string(forKey: "ChaipayKey")
    }
    
    static var getSecretKey: String? {
        return shared.string(forKey: "SecretKey")
        
    }
    
    static var getEnvironment: EnvObject? {
        if let data = shared.data(forKey: "env") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let environmentObject = try decoder.decode(EnvObject.self, from: data)
                return environmentObject
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return EnvObject(index: 0, environmentTitle: "Sandbox", envType: "sandbox")
    }
    
    static var getDevEnv: DevEnvObject? {
        if let data = shared.data(forKey: "devENV") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let environmentObject = try decoder.decode(DevEnvObject.self, from: data)
                return environmentObject
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return DevEnvObject(index: 0, environmentTitle: "Dev", envType: "dev")
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
