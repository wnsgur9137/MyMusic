//
//  UserDefaultsStorage.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation

protocol UserDefaultsStorage {
    func fetchMusicAuthorization() async -> Result<Bool, Error>
    func saveMusicAuthorization(_ bool: Bool)
}
