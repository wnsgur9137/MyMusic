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
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {
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
    
    init(homeUseCase: HomeUseCase,
         musicUseCase: MusicUseCase,
         actions: HomeViewModelActions? = nil) {
        self.homeUseCase = homeUseCase
        self.musicUseCase = musicUseCase
        self.actions = actions
        
        notificationCenter.addObserver(self, selector: #selector(loadRecentPlayed), name: .musicAuth, object: nil)
    }
    
    @objc private func loadRecentPlayed() {
        let auth = UserDefaults.standard.bool(forKey: "musicAuth")
        guard auth else { return }
        musicUseCase.loadRecentlyPlayed()
    }
    
    private func load(isMusicAuth: Bool) {
        self.isMusicAuth = isMusicAuth
        self.musicAuthRelay.accept(self.isMusicAuth)
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
//                self.load(isMusicAuth: auth)
            })
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad(_ viewDidLoad: Observable<Void>) {
        viewDidLoad
            .subscribe(onNext: {_ in
                self.musicUseCase.loadRecentlyPlayed()
            })
            .disposed(by: disposeBag)
    }
    
    func viewWillAppear(_ viewWillAppear: Observable<Void>) {
        viewWillAppear
            .subscribe(onNext: { _ in
                guard self.isMusicAuth else { return }
                self.musicUseCase.loadRecentlyPlayed()
            })
            .disposed(by: disposeBag)
    }
}
