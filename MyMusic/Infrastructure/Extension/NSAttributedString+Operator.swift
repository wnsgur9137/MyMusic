//
//  NSAttributedString+Operator.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/12/24.
//

import UIKit

extension NSAttributedString {
    static func button1(string: String,
                        color: UIColor,
                        alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        let font = Constants.Font.button1
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle,
                                                               .foregroundColor: color, .font: font, .kern: -0.4])
    }
}
