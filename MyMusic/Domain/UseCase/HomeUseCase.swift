//
//  HomeUseCase.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import Foundation

protocol HomeUseCase {
    
}

final class DefaultHomeUseCase: HomeUseCase {
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository) {
        self.homeRepository = homeRepository
    }
}
