//
//  NavigationView.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

final class NavigationView: UIView {
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .light)
        view.effect = blurEffect
        view.alpha = 0.98
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = .dynamicBlack
        button.isHidden = true
        return button
    }()
    
//    private lazy var imageView: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24.0, height: 24.0))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Font.subtitleSemiBold1
        label.textColor = .dynamicBlack
        label.textAlignment = .left
        return label
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        return view
    }()
    
    private let contentViewHeight: CGFloat
    
    init(title: String? = nil,
         image: UIImage? = nil,
         height: CGFloat = 56.0) {
        self.contentViewHeight = height
        super.init(frame: .zero)
        
        titleLabel.text = title
//        imageView.image = image
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationView {
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout
extension NavigationView {
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backwardButton.widthAnchor.constraint(equalToConstant: 24.0),
            backwardButton.heightAnchor.constraint(equalToConstant: 24.0),
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentViewHeight),
            
            backwardButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            backwardButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
//            imageView.leadingAnchor.constraint(equalTo: backwardButton.trailingAnchor, constant: 12.0),
//            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 24.0),
//            imageView.heightAnchor.constraint(equalToConstant: 24.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: backwardButton.trailingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            bottomBorderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorderView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Add subviews
extension NavigationView {
    private func addSubviews() {
        addSubview(blurView)
        addSubview(contentView)
        contentView.addSubview(backwardButton)
//        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        addSubview(bottomBorderView)
    }
}
