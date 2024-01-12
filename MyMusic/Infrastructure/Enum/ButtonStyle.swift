//
//  ButtonStyle.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/12/24.
//

import UIKit

enum ButtonSize {
    case large
    case medium
    
    var buttonHeight: CGFloat {
        switch self {
        case .large: 64
        case .medium: 34
        }
    }
    
    var borderWidth: CGFloat {
        return 1.0
    }
}

enum ButtonStyle {
    case fill
    case outline
    case cancel
    
    var enableBackgroundColor: UIColor {
        switch self {
        case .fill: return .lightPurple
        case .outline: return .dynamicWhite
        case .cancel: return .dynamicWhite
        }
    }
    
    var enableTitleColor: UIColor {
        switch self {
        case .fill: return .dynamicWhite
        case .outline: return .dynamicBlack
        case .cancel: return .dynamicBlack
        }
    }
    
    var enableBorderColor: CGColor {
        switch self {
        case .fill: return UIColor.clear.cgColor
        case .outline: return UIColor.lightPurple.cgColor
        case .cancel: return UIColor.lightGray.cgColor
        }
    }
    
    var disableBackgroundColor: UIColor {
        return .dynamicWhite
    }
    
    var disableTitleColor: UIColor {
        return .darkGray
    }
    
    var disableBorderColor: CGColor {
        return UIColor.lightGray.cgColor
    }
    
    var selectedBackground: UIColor {
        switch self {
        case .fill: return .purple
        case .outline: return .dynamicWhite
        case .cancel: return .dynamicWhite
        }
    }
    
    var selectedTitleColor: UIColor {
        switch self {
        case .fill: return .dynamicWhite
        case .outline: return .dynamicBlack
        case .cancel: return .dynamicBlack
        }
    }
}
