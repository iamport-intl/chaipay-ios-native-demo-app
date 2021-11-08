//
//  EnvironmentDataManager.swift
//  ShoppingApp
//
//  Created by Sireesha Neelapu on 05/11/21.
//

import Foundation

struct EnvironmentObject: Codable {
    var environmentTitle: String
    var key: String
    var secretKey: String
}

class EnvironmentDataManager {
    static func prepareEnvironmentData() -> [EnvironmentObject] {
        let devSiriEnvironment = EnvironmentObject(environmentTitle: "Dev Siri", key: "bCktzybHOqyfTjrp", secretKey: "17fd4b860101361129e5bc3d26b7c8ff80d47f7d514e8eba66e9c95f5321b123")
        let devAagamEnvironment = EnvironmentObject(environmentTitle: "Dev Aagam", key: "aiHKafKIbsdUJDOb", secretKey: "2601efeb4409f7027da9cbe856c9b6b8b25f0de2908bc5322b1b352d0b7eb2f5")
        let devTestMerchantEnvironment = EnvironmentObject(environmentTitle: "testMerchant", key: "SglffyyZgojEdXWL", secretKey: "a3b8281f6f2d3101baf41b8fde56ae7f2558c28133c1e4d477f606537e328440")
        let devTestMerchant2Environment = EnvironmentObject(environmentTitle: "testMerchant2", key: "lzrYFPfyMLROallZ", secretKey: "0e94b3232e1bf9ec0e378a58bc27067a86459fc8f94d19f146ea8249455bf242")
        return [devSiriEnvironment, devAagamEnvironment, devTestMerchantEnvironment, devTestMerchant2Environment]
    }
}
