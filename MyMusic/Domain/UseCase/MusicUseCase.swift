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
    func fetchMusicAuthorization() async -> Result<Bool, Error>
    func saveMusicAuthorization(_ bool: Bool)
    func executeRecentlyPlayed() async -> Result<[RecentlyPlayedMusicItem], Error>
    func executeRecommend() async -> Result<[MusicPersonalRecommendation], Error>
}

final class DefaultMusicUseCase: MusicUseCase {
    
    private let musicRepository: MusicRepository
    
    init(musicRepository: MusicRepository) {
        self.musicRepository = musicRepository
    }
    
    private func save(auth: MusicAuthorization.Status) {
        UserDefaults.standard.setValue(auth == .authorized, forKey: "musicAuth")
    }
}

extension DefaultMusicUseCase {
    func requestMusicAuthorization() async -> MusicAuthorization.Status {
        return await MusicAuthorization.request()
    }
    
    func executeRecentlyPlayed() async -> Result<[RecentlyPlayedMusicItem], Error> {
        return await musicRepository.requestRecentlyPlayed()
    }
    
    func executeRecommend() async -> Result<[MusicPersonalRecommendation], Error> {
        return await musicRepository.requestRecommend()
    }
    
    func fetchMusicAuthorization() async -> Result<Bool, Error> {
        return await musicRepository.fetchMusicAuthorization()
    }
    
    func saveMusicAuthorization(_ bool: Bool) {
        musicRepository.saveMusicAuthorization(bool)
    }
}

