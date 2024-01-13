//
//  TabBarPage.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

enum TabBarPage {
    case home
    case setting
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .setting
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .setting:
            return "Setting"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .setting:
            return 1
        }
    }
    
    func pageIconDataValue() -> UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house") ?? .init()
        case .setting:
            return UIImage(systemName: "gear") ?? .init()
        }
    }
    
    func pageSelectedIconDataValue() -> UIImage {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill") ?? .init()
        case .setting:
            return UIImage(systemName: "gear.circle.fill") ?? .init()
        }
    }
}
