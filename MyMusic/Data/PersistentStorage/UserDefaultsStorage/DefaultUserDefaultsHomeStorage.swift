//
//  DefaultsUserDefaultsHomeStorage.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation

enum UserDefaultsError: Error {
    case isNull
}

final class DefaultUserDefaultsStorage {
    private let userDefaultService: UserDefaultService
    
    init(userDefaultService: UserDefaultService) {
        self.userDefaultService = userDefaultService
    }
}

extension DefaultUserDefaultsStorage: UserDefaultsStorage {
    func fetchMusicAuthorization() async -> Result<Bool, Error> {
        guard let value = userDefaultService.value(for: .musicAuthorization) else {
            return .failure(UserDefaultsError.isNull)
        }
        return .success(value)
    }
    
    func saveMusicAuthorization(_ bool: Bool) {
        userDefaultService.set(value: bool, for: .musicAuthorization)
    }
}
