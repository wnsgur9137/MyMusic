//
//  PermissionViewModel.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/11/24.
//

import Foundation

protocol PermissionViewModelInput {
    func requestMusicAuthorization()
}

protocol PermissionViewModelOutput {
    
}

protocol PermissionViewModel: PermissionViewModelInput, PermissionViewModelOutput { }

final class DefaultPermissionViewModel: PermissionViewModel {
    let musicUseCase: MusicUseCase
    
    init(musicUseCase: MusicUseCase) {
        self.musicUseCase = musicUseCase
    }
}

extension DefaultPermissionViewModel {
    func requestMusicAuthorization() {
        Task {
            let auth = await musicUseCase.requestMusicAuthorization()
        }
    }
}
