//
//  UIView+Shadow.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/12/24.
//

import UIKit

extension UIView {
    var containedShadow: Bool {
        set {
            if newValue {
                layer.applySketchShadow(
                    color: UIColor.dynamicBlack,
                    alpha: 0.2,
                    width: 4.0,
                    height: 4.0,
                    blur: 8.0,
                    spread: 0
                )
            } else {
                layer.masksToBounds = true
                layer.shadowColor = UIColor.dynamicBlack.cgColor
                layer.shadowOpacity = 0
                layer.shadowOffset = .zero
                layer.shadowRadius = 0
                layer.shadowPath = nil
            }
        }
        get {
            return layer.shadowRadius == 0 ? true : false
        }
    }
}
