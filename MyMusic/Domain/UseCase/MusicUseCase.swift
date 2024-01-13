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
    func loadRecentlyPlayed()
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
    
    func loadRecentlyPlayed() {
        Task {
            do {
                let recentlyPlayedRequest = MusicRecentlyPlayedContainerRequest()
                let recentlyPlayedResponse = try await recentlyPlayedRequest.response()
                print("recentlyPlayedResponse: \(recentlyPlayedResponse)")
            } catch {
                
            }
        }
    }
    
    
    func fetchMusicAuthorization() async -> Result<Bool, Error> {
        return await musicRepository.fetchMusicAuthorization()
    }
    
    func saveMusicAuthorization(_ bool: Bool) {
        musicRepository.saveMusicAuthorization(bool)
    }
}

