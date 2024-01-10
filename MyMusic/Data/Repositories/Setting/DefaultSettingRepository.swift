//
//  DefaultSettingRepository.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation

final class DefaultSettingRepository {
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultSettingRepository: SettingRepository {
    
}
