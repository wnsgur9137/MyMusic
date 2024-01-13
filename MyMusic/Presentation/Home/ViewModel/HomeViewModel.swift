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
    
}

protocol HomeViewModelInput {
    func viewDidLoad(_ observable: Observable<Void>)
    func requestPermission(_ observable: Observable<Void>)
}

protocol HomeViewModelOutput {
    var recentlyPlayed: Driver<Void> { get }
    var musicAuth: Driver<Bool> { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {
    private let homeUseCase: HomeUseCase
    private let actions: HomeViewModelActions?
    private let disposeBag = DisposeBag()
    
    var recentlyPlayedRelay: PublishRelay<Void> = .init()
    var recentlyPlayed: Driver<Void> = .never()
    
    var musicAuthRelay: PublishRelay<Bool> = .init()
    var musicAuth: Driver<Bool> {
        return musicAuthRelay.asDriver(onErrorDriveWith: .never())
    }
    
    init(homeUseCase: HomeUseCase,
         actions: HomeViewModelActions? = nil) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
}

extension DefaultHomeViewModel {
    func requestPermission(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { _ in
                
                let auth = UserDefaults.standard.bool(forKey: "musicAuth")
                print("userDefaults Auth: \(auth)")
                self.musicAuthRelay.accept(auth)
                
//                Task {
//                    let auth = await self.homeUseCase.requestMusicAuthorization()
//                    self.musicAuthRelay.accept(auth == .authorized)
//                }
            })
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad(_ viewDidLoad: Observable<Void>) {
        viewDidLoad
            .subscribe(onNext: {_ in
                self.homeUseCase.loadRecentlyPlayed()
            })
            .disposed(by: disposeBag)
    }
}
