//
//  MusicRepository.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation

protocol MusicRepository {
    func fetchMusicAuthorization() async -> Result<Bool, Error>
    func saveMusicAuthorization(_ bool: Bool)
}
