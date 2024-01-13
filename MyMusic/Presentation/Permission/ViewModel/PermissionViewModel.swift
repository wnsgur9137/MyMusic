//
//  PermissionViewModel.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/11/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol PermissionViewModelInput {
    func requestMusicAuthorization()
}

protocol PermissionViewModelOutput {
    var musicAuth: Driver<Bool> { get }
}

protocol PermissionViewModel: PermissionViewModelInput, PermissionViewModelOutput { }

final class DefaultPermissionViewModel: PermissionViewModel {
    private let musicUseCase: MusicUseCase
    private let disposeBag = DisposeBag()
    private let notificationCenter = NotificationCenter.default
    
    private var musicAuthRelay: PublishRelay<Bool> = .init()
    var musicAuth: Driver<Bool> {
        return musicAuthRelay.asDriver(onErrorDriveWith: .never())
    }
    
    init(musicUseCase: MusicUseCase) {
        self.musicUseCase = musicUseCase
    }
}

extension DefaultPermissionViewModel {
    func requestMusicAuthorization() {
        Task {
            let auth = await musicUseCase.requestMusicAuthorization()
            musicUseCase.saveMusicAuthorization(auth == .authorized)
            notificationCenter.post(name: .musicAuth, object: nil)
            musicAuthRelay.accept(auth == .authorized)
        }
    }
}
