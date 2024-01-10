//
//  AppConfiguration.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation

final class AppConfiguration {
    private let appConfigurations: [String: String] = {
        guard let appConfigurations = Bundle.main.infoDictionary?["AppConfigurations"] as? [String: String] else {
            fatalError("AppConfigurations must not be empty in plist")
        }
        return appConfigurations
    }()
    
    lazy var apiKey: String = {
        guard let apiKey = appConfigurations["API_KEY"] else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = appConfigurations["API_BASE_URL"] else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
