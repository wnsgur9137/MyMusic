//
//  SettingViewModel.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation

struct SettingViewModelActions {
    
}

protocol SettingViewModelInput {
    
}

protocol SettingViewModelOutput {
    
}

protocol SettingViewModel: SettingViewModelInput, SettingViewModelOutput { }

final class DefaultSettingViewModel: SettingViewModel {
    private let settingUseCase: SettingUseCase
    private let actions: SettingViewModelActions?
    
    init(settingUseCase: SettingUseCase,
         actions: SettingViewModelActions? = nil) {
        self.settingUseCase = settingUseCase
        self.actions = actions
    }
    
}
