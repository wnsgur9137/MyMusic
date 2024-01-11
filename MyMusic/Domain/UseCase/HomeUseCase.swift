//
//  HomeUseCase.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation
import MusicKit

protocol HomeUseCase {
    func loadRecentlyPlayed()
    func requestMusicAuthorization() async -> MusicAuthorization.Status
}

final class DefaultHomeUseCase: HomeUseCase {
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
}

extension DefaultHomeUseCase {
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
}
