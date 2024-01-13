//
//  DefaultMusicRepository.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation

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
}
