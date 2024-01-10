//
//  SettingCoordinator.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

protocol SettingCoordinatorDependencies {
    func makeSettingViewController(actions: SettingViewModelActions) -> SettingViewController
}

protocol SettingCoordinatorProtocol: Coordinator {
    func showSettingViewController()
}

final class SettingCoordinator: SettingCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .setting }
    
    private let dependencies: SettingCoordinatorDependencies
    private weak var settingViewController: SettingViewController?
    
    init(navigationController: UINavigationController,
         dependencies: SettingCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showSettingViewController()
    }
    
    func showSettingViewController() {
        let actions = SettingViewModelActions()
        let viewController = dependencies.makeSettingViewController(actions: actions)
        
        navigationController?.pushViewController(viewController, animated: false)
        settingViewController = viewController
    }
}
