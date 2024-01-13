//
//  HomeViewModel.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import MusicKit

struct HomeViewModelActions {
    let presentPermissionViewController: () -> Void
}

protocol HomeViewModelInput {
    func viewDidLoad(_ observable: Observable<Void>)
    func requestPermission(_ observable: Observable<Void>)
    func viewWillAppear(_ observable: Observable<Void>)
}

protocol HomeViewModelOutput {
    var recentlyPlayed: Driver<Void> { get }
    var musicAuth: Driver<Bool> { get }
    var loadedPlayedMusicItemDriver: Driver<Void> { get }
    var loadedRecommendMusicItemDriver: Driver<[String]> { get }
}

protocol HomeViewModel: HomeViewModelInput,
                        HomeViewModelOutput,
                        HomeRecentlyCollectionViewDataSource,
                        HomeRecommendCollectionViewDataSource { }

final class DefaultHomeViewModel: HomeViewModel {
//    typealias recommendMusicInfo = (id: MusicItemID, title: String)
    private let homeUseCase: HomeUseCase
    private let musicUseCase: MusicUseCase
    private let actions: HomeViewModelActions?
    private let disposeBag = DisposeBag()
    private let notificationCenter = NotificationCenter.default
    
    var recentlyPlayedRelay: PublishRelay<Void> = .init()
    var recentlyPlayed: Driver<Void> = .never()
    
    private var isMusicAuth: Bool = false
    private var musicAuthRelay: PublishRelay<Bool> = .init()
    var musicAuth: Driver<Bool> {
        return musicAuthRelay.asDriver(onErrorDriveWith: .never())
    }
    
    private var recentlyPlayedMusicItems: [RecentlyPlayedMusicItem] = []
    private var loadedPlayedMusicItemRelay: PublishRelay<Void> = .init()
    var loadedPlayedMusicItemDriver: Driver<Void> {
        return loadedPlayedMusicItemRelay.asDriver(onErrorDriveWith: .never())
    }
    
    private var recommendMusicItems: [MusicPersonalRecommendation] = []
    private var loadedRecommendMusicItemRelay: PublishRelay<[String]> = .init()
    var loadedRecommendMusicItemDriver: Driver<[String]> {
        return loadedRecommendMusicItemRelay.asDriver(onErrorDriveWith: .never())
    }
    
    init(homeUseCase: HomeUseCase,
         musicUseCase: MusicUseCase,
         actions: HomeViewModelActions? = nil) {
        self.homeUseCase = homeUseCase
        self.musicUseCase = musicUseCase
        self.actions = actions
        
        notificationCenter.addObserver(self, selector: #selector(reloadData), name: .musicAuth, object: nil)
    }
    
    @objc func reloadData() {
        let auth = UserDefaults.standard.bool(forKey: "musicAuth")
        guard auth else { return }
        loadRecentPlayed()
        loadRecommend()
    }
    
    private func loadRecentPlayed() {
        Task {
            let result = await musicUseCase.executeRecentlyPlayed()
            switch result {
            case .success(let items):
                self.load(recentlyPlayedMusics: items)
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadRecommend() {
        Task {
            let result = await musicUseCase.executeRecommend()
            switch result {
            case .success(let items):
                self.load(recommendMusics: items)
                
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    private func load(isMusicAuth: Bool) {
        self.isMusicAuth = isMusicAuth
        self.musicAuthRelay.accept(self.isMusicAuth)
    }
    
    private func load(recentlyPlayedMusics items: [RecentlyPlayedMusicItem]) {
        self.recentlyPlayedMusicItems = items
        self.loadedPlayedMusicItemRelay.accept(Void())
    }
    
    private func load(recommendMusics items: [MusicPersonalRecommendation]) {
        self.recommendMusicItems = items.filter{ $0.title != "Recently Played" }
        let titles = self.recommendMusicItems.map {
//            (id: $0.id, title: $0.title ?? Constants.HomeViewController.recommedMusics)
            $0.title ?? Constants.HomeViewController.recommedMusics
        }
        self.loadedRecommendMusicItemRelay.accept(titles)
    }
}

extension DefaultHomeViewModel {
    func requestPermission(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { _ in
                let auth = UserDefaults.standard.bool(forKey: "musicAuth")
                if auth == false {
                    self.actions?.presentPermissionViewController()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad(_ viewDidLoad: Observable<Void>) {
        viewDidLoad
            .subscribe(onNext: {_ in
                self.loadRecentPlayed()
                self.loadRecommend()
            })
            .disposed(by: disposeBag)
    }
    
    func viewWillAppear(_ viewWillAppear: Observable<Void>) {
        viewWillAppear
            .subscribe(onNext: { _ in
                guard self.isMusicAuth else { return }
                self.loadRecentPlayed()
                self.loadRecommend()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - RecentlryCollectionView DataSource
extension DefaultHomeViewModel: HomeRecentlyCollectionViewDataSource {
    func numberOfItems() -> Int {
        return recentlyPlayedMusicItems.count
    }
    
    func cellForItem(at index: Int) -> RecentlyPlayedMusicItem {
        return recentlyPlayedMusicItems[index]
    }
}

// MARK: - RecommendCollectionView DataSource
extension DefaultHomeViewModel: HomeRecommendCollectionViewDataSource {
    func numberOfItems(tag index: Int) -> Int {
        return recommendMusicItems[index].items.count
    }
    
    func cellForItem(tag index: Int, at itemIndex: Int) -> MusicPersonalRecommendation.Item {
        return recommendMusicItems[index].items[itemIndex]
    }
}
