//
//  SettingUseCase.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation

protocol SettingUseCase {
    
}

final class DefaultSettingUseCase: SettingUseCase {
    private let settingRepository: SettingRepository
    
    init(settingRepository: SettingRepository) {
        self.settingRepository = settingRepository
    }
}
