//
//  AppFlowCoordinator.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

final class AppFlowCoordinator {
    var tabBarController: UITabBarController
    private let appDIContainer: AppDIContainer
    
    init(tabBarController: UITabBarController,
         appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let flow = mainSceneDIContainer.makeTabBarFlowCoordinator(tabBarController: tabBarController)
        flow.start()
    }
}
