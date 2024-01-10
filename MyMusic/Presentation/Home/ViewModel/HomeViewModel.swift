//
//  HomeViewModel.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation
import MusicKit

struct HomeViewModelActions {
    
}

protocol HomeViewModelInput {
    
}

protocol HomeViewModelOutput {
    
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {
    private let homeUseCase: HomeUseCase
    private let actions: HomeViewModelActions?
    
    init(homeUseCase: HomeUseCase,
         actions: HomeViewModelActions? = nil) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
}
