//
//  HomeContentView.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import UIKit

final class HomeContentView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.HomeViewController.recentlyPlayed
        label.textColor = .dynamicWhite
        label.font = Constants.Font.headlineSemibold1
        label.textAlignment = .center
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.HomeViewController.recentlySubtitle
        label.textColor = .dynamicWhite
        label.font = Constants.Font.subtitleSemiBold4
        label.textAlignment = .center
        return label
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    var height: CGFloat = 300 {
        didSet {
            heightConstarint.constant = height
        }
    }
    private var heightConstarint: NSLayoutConstraint {
        heightAnchor.constraint(equalToConstant: 300)
    }
    
    init() {
        super.init(frame: .zero)
        containedShadow = true
        backgroundColor = .dynamicBlack
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout
extension HomeContentView {
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24.0),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0),
            
            buttonStackView.centerXAnchor.constraint(equalTo: subTitleLabel.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 12.0),
            
            heightConstarint
        ])
    }
}

// MARK: - Add Subivews
extension HomeContentView {
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(buttonStackView)
    }
}
