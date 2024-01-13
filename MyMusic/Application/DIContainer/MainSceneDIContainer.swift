//
//  MainSceneDIContainer.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

final class MainSceneDIContainer {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let userDefaultService: UserDefaultService
    }
    
    private let dependencies: Dependencies
    private lazy var userDefaultsStorage: UserDefaultsStorage = DefaultUserDefaultsStorage(userDefaultService: dependencies.userDefaultService)
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTabBarFlowCoordinator(tabBarController: UITabBarController) -> TabBarFlowCoordinator {
        return TabBarFlowCoordinator(
            tabBarController: tabBarController,
            homeTabDependencies: self,
            settingTabDependencies: self
        )
    }
}

// MARK: - Music
extension MainSceneDIContainer {
    func makeMusicRepository() -> MusicRepository {
        return DefaultMusicRepository(dataTransferService: dependencies.apiDataTransferService,
                                      userDefaultsStorage: userDefaultsStorage)
    }
    
    func makeMusicUseCase() -> MusicUseCase {
        return DefaultMusicUseCase(musicRepository: makeMusicRepository())
    }
}

// MARK: - HomeTab Coordiantor Dependencies
extension MainSceneDIContainer: HomeTabCoordinatorDependencies {
    func makePermissionViewModel() -> PermissionViewModel {
        return DefaultPermissionViewModel(musicUseCase: makeMusicUseCase())
    }
    
    func makePermissionViewController() -> PermissionViewController {
        return PermissionViewController(with: makePermissionViewModel())
    }
    
    func makeHomeRepository() -> HomeRepository {
        return DefaultHomeRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeHomeUseCase() -> HomeUseCase {
        return DefaultHomeUseCase(homeRepository: makeHomeRepository())
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return DefaultHomeViewModel(homeUseCase: makeHomeUseCase(),
                                    musicUseCase: makeMusicUseCase(),
                                    actions: actions)
    }
    
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        return HomeViewController.create(with: makeHomeViewModel(actions: actions))
    }
}

// MARK: - SettingTab Coordinator Dependencies
extension MainSceneDIContainer: SettingTabCoordinatorDependencies {
    func makeSettingRepository() -> SettingRepository {
        return DefaultSettingRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeSettingUseCase() -> SettingUseCase {
        return DefaultSettingUseCase(settingRepository: makeSettingRepository())
    }
    
    func makeSettingViewModel(actions: SettingViewModelActions) -> SettingViewModel {
        return DefaultSettingViewModel(settingUseCase: makeSettingUseCase(), actions: actions)
    }
    
    func makeSettingViewController(actions: SettingViewModelActions) -> SettingViewController {
        return SettingViewController.create(with: makeSettingViewModel(actions: actions))
    }
}
