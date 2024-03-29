//
//  MusicRepository.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import Foundation
import MusicKit

protocol MusicRepository {
    func fetchMusicAuthorization() async -> Result<Bool, Error>
    func saveMusicAuthorization(_ bool: Bool)
    func requestRecentlyPlayed() async -> Result<[RecentlyPlayedMusicItem], Error>
    func requestRecommend() async -> Result<[MusicPersonalRecommendation], Error>
}
