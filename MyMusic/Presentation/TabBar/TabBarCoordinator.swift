//
//  TabBarCoordinator.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

protocol HomeTabCoordinatorDependencies {
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
}

protocol SettingTabCoordinatorDependencies {
    func makeSettingViewController(actions: SettingViewModelActions) -> SettingViewController
}

protocol TabBarFlowCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController? { get set }
}

final class TabBarFlowCoordinator: TabBarFlowCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var navigationController: UINavigationController?
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    weak var tabBarController: UITabBarController?
    private let homeTabDependencies: HomeTabCoordinatorDependencies
    private let settingTabDependencies: SettingTabCoordinatorDependencies
    
    private weak var homeViewController: HomeViewController?
    private weak var settingViewController: SettingViewController?
    
    init(tabBarController: UITabBarController,
         homeTabDependencies: HomeTabCoordinatorDependencies,
         settingTabDependencies: SettingTabCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.homeTabDependencies = homeTabDependencies
        self.settingTabDependencies = settingTabDependencies
    }
    
    func start() {
        let pages: [TabBarPage] = [.home, .setting]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(with: controllers)
    }
    
    private func prepareTabBarController(with controllers: [UINavigationController]) {
        tabBarController?.setViewControllers(controllers, animated: true)
        tabBarController?.selectedIndex = TabBarPage.home.pageOrderNumber()
        tabBarController?.tabBar.isTranslucent = false
//        tabBarController?.tabBar.backgroundColor = .dynamicBlack
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
//        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.tabBarItem = UITabBarItem(title: page.pageTitleValue(), image: page.pageIconDataValue(), selectedImage: page.pageSelectedIconDataValue())
        
        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController, dependencies: self)
            homeCoordinator.finishDelegate = self
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
            
        case .setting:
            let settingCoordinator = SettingCoordinator(navigationController: navigationController, dependencies: self)
            settingCoordinator.finishDelegate = self
            settingCoordinator.start()
            childCoordinators.append(settingCoordinator)
        }
        return navigationController
    }
}

extension TabBarFlowCoordinator: HomeCoordinatorDependencies {
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        self.homeTabDependencies.makeHomeViewController(actions: actions)
    }
}

extension TabBarFlowCoordinator: SettingCoordinatorDependencies {
    func makeSettingViewController(actions: SettingViewModelActions) -> SettingViewController {
        self.settingTabDependencies.makeSettingViewController(actions: actions)
    }
}

extension TabBarFlowCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        switch childCoordinator.type {
        case .home:
            navigationController?.viewControllers.removeAll()
            
        case .setting:
            navigationController?.viewControllers.removeAll()
            
        default:
            break
        }
    }
}
