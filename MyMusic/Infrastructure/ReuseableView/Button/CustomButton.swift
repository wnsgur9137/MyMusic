//
//  FilledButton.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/12/24.
//

import UIKit

final class CustomButton: UIButton {
    private let buttonSize: ButtonSize
    private let buttonStyle: ButtonStyle
    
    private var buttonTitleColor: UIColor {
        isEnabled ? buttonStyle.enableTitleColor : buttonStyle.disableTitleColor
    }
    
    private var buttonBackgroundColor: UIColor {
        isEnabled ? buttonStyle.enableBackgroundColor : buttonStyle.disableBackgroundColor
    }
    
    private var buttonBorderColor: CGColor {
        isEnabled ? buttonStyle.enableBorderColor : buttonStyle.disableBorderColor
    }
    
    private lazy var selectedTitleColor: UIColor = buttonStyle.selectedTitleColor
    
    private lazy var selectedBackgroundColor: UIColor = buttonStyle.selectedBackground
    
    override var isEnabled: Bool {
        didSet {
            self.containedButtonShadow = self.isEnabled
            let currentTitle = self.attributedTitle(for: .normal)?.string ?? ""
            let attributedTitle = NSAttributedString.button1(string: currentTitle, color: self.buttonTitleColor)
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.buttonBackgroundColor
                self.setAttributedTitle(attributedTitle, for: .normal)
                self.layer.borderColor = self.buttonBorderColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            let color: UIColor = newValue ? selectedTitleColor : buttonTitleColor
            let currentTitle = self.attributedTitle(for: .normal)?.string ?? ""
            let attributedTitle = NSAttributedString.button1(string: currentTitle, color: color)
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .allowUserInteraction) {
                    self.backgroundColor = newValue ? self.selectedBackgroundColor : self.buttonBackgroundColor
                    self.setAttributedTitle(attributedTitle, for: .normal)
            }
            super.isHighlighted = newValue
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let baseSize = super.intrinsicContentSize
            return CGSize(width: baseSize.width + 48, height: baseSize.height)
        }
    }
    lazy var buttonCornerRadius: CGFloat = buttonSize.buttonHeight / 2 {
        didSet {
            layer.cornerRadius = buttonCornerRadius
        }
    }
    
    var touchUpAnimationTime: Double = 0.2
    var buttonTitle: String {
        get {
            "\(self.titleLabel?.attributedText ?? .init(string: ""))"
        }
        set {
            let attributedString = NSAttributedString.button1(string: newValue, color: self.buttonTitleColor)
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        self.buttonStyle = .fill
        self.buttonSize = .large
        super.init(frame: frame)
        setupButton()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .allowUserInteraction) {
            self.containedButtonShadow = false
        }
        return super.beginTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animateToNormal()
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animateToNormal()
    }
    
    init(style: ButtonStyle, size: ButtonSize) {
        self.buttonStyle = style
        self.buttonSize = size
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = buttonBackgroundColor
        adjustsImageWhenHighlighted = false
        layer.cornerRadius = buttonCornerRadius
        layer.borderWidth = 0.2
        layer.borderColor = buttonBorderColor
        containedButtonShadow = isEnabled
    }
    
    private func animateToNormal() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .allowUserInteraction) {
            self.containedButtonShadow = self.isEnabled
        }
    }
}
