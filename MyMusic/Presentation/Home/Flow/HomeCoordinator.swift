//
//  HomeCoordinator.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit
import MusicKit

protocol HomeCoordinatorDependencies {
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
    func makePermissionViewController() -> PermissionViewController
    func makeRecentlyDetailViewController(item: RecentlyPlayedMusicItem) -> UIViewController
    func makeRecommendDetailViewController(item: MusicPersonalRecommendation.Item) -> UIViewController
}

protocol HomeCoordinatorProtocol: Coordinator {
    func showHomeViewController()
}

final class HomeCoordinator: HomeCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .home }
    
    private let dependencies: HomeCoordinatorDependencies
    private weak var homeViewController: HomeViewController?
    
    init(navigationController: UINavigationController,
         dependencies: HomeCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showHomeViewController()
    }
    
    func showHomeViewController() {
        let actions = HomeViewModelActions(
            presentPermissionViewController: presentPermissionViewController,
        pushRecentlyDetailViewController: pushDetailViewController,
        pushRecommendDetailViewcontroller: pushDetailViewController)
        let viewController = dependencies.makeHomeViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: false)
        homeViewController = viewController
    }
    
    func presentPermissionViewController() {
        let viewController = dependencies.makePermissionViewController()
        navigationController?.present(viewController, animated: true)
    }
    
    func pushDetailViewController(_ item: RecentlyPlayedMusicItem) {
        let viewController = dependencies.makeRecentlyDetailViewController(item: item)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushDetailViewController(_ item: MusicPersonalRecommendation.Item) {
        let viewController = dependencies.makeRecommendDetailViewController(item: item)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
