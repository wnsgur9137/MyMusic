//
//  MusicUseCase.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/11/24.
//

import Foundation
import MusicKit

protocol MusicUseCase {
    func requestMusicAuthorization() async -> MusicAuthorization.Status
}

final class DefaultMusicUseCase: MusicUseCase {
    private func save(auth: MusicAuthorization.Status) {
        UserDefaults.standard.setValue(auth == .authorized, forKey: "musicAuth")
    }
}

extension DefaultMusicUseCase {
    func requestMusicAuthorization() async -> MusicAuthorization.Status {
        let auth = await MusicAuthorization.request()
        print("auth: \(auth)")
        return auth
    }
}

