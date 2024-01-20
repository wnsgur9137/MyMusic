//
//  NavigationView.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit
import FlexLayout
import PinLayout

final class NavigationView: UIView {
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: .light)
        view.effect = blurEffect
        view.alpha = 0.98
        return view
    }()
    
    private let contentView = UIView()
    
    lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = .dynamicBlack
        button.isHidden = true
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.subtitleSemiBold1
        label.textColor = .dynamicBlack
        label.textAlignment = .left
        return label
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        return view
    }()
    
    private let contentViewHeight: CGFloat
    
    init(title: String? = nil,
         height: CGFloat = 56.0) {
        self.contentViewHeight = height
        super.init(frame: .zero)
        
        titleLabel.text = title
        
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

extension NavigationView {
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout
extension NavigationView {
    private func addSubviews() {
        addSubview(blurView)
        addSubview(contentView)
    }
    
    private func setupLayout() {
        contentView.flex
            .direction(.row)
            .alignItems(.center)
            .define { contentView in
                contentView.addItem(backwardButton)
                    .marginLeft(24.0)
                    .width(24.0)
                    .height(24.0)
                contentView.addItem(titleLabel)
                    .marginLeft(16.0)
        }
    }
    
    private func setupSubviewLayout() {
        blurView.pin.all()
        blurView.flex.layout()
        
        contentView.pin
            .all()
            .marginTop(safeAreaInsets.top)
        contentView.flex.layout()
        
        pin.height(safeAreaInsets.top + contentViewHeight)
    }
}
