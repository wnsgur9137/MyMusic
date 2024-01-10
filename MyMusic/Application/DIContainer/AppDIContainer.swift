//
//  AppDIContainer.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "api_key": appConfiguration.apiKey,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return MainSceneDIContainer(dependencies: dependencies)
    }
    
}
