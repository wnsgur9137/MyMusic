//
//  MainSceneDIContainer.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit
import MusicKit

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
    func makeRecentlyDetailViewModel(item: RecentlyPlayedMusicItem) -> HomeRecentlyDetailViewModel {
        return DefaultHomeRecentlyDetailViewModel(item: item)
    }
    
    func makeRecentlyDetailViewController(item: RecentlyPlayedMusicItem) -> HomeRecentlyDetailViewController {
        return HomeRecentlyDetailViewController(with: makeRecentlyDetailViewModel(item: item))
    }
    
    func makeRecommendDetailViewModel(item: MusicPersonalRecommendation.Item) -> HomeRecommendDetailViewModel {
        return DefaultHomeRecommendDetailViewModel(item: item)
    }
    
    func makeRecommendDetailViewController(item: MusicPersonalRecommendation.Item) -> HomeRecommendDetailViewController {
        return HomeRecommendDetailViewController(with: makeRecommendDetailViewModel(item: item))
    }
    
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
