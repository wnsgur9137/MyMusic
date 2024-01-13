//
//  DefaultMusicRepository.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation
import MusicKit

enum MusicKitError: Error {
    case loadError
    case accessApple
}

final class DefaultMusicRepository {
    private let dataTransferService: DataTransferService
    private var userDefaultsStorage: UserDefaultsStorage
    
    init(dataTransferService: DataTransferService,
         userDefaultsStorage: UserDefaultsStorage) {
        self.dataTransferService = dataTransferService
        self.userDefaultsStorage = userDefaultsStorage
    }
}

extension DefaultMusicRepository: MusicRepository {
    func fetchMusicAuthorization() async -> Result<Bool, Error> {
        return await userDefaultsStorage.fetchMusicAuthorization()
    }
    
    func saveMusicAuthorization(_ bool: Bool) {
        userDefaultsStorage.saveMusicAuthorization(bool)
    }
    
    func requestRecentlyPlayed() async -> Result<[RecentlyPlayedMusicItem], Error> {
        do {
            let request = MusicRecentlyPlayedContainerRequest()
            let response = try await request.response()
            var musicItems: [RecentlyPlayedMusicItem] = response.items.map{ $0 }
            return .success(musicItems)
        } catch {
            return .failure(MusicKitError.loadError)
        }
    }
}
