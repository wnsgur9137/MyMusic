//
//  HomeContentView.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import UIKit

final class HomeContentView: UIView {
    
    private let rootFlexContainerView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeViewController.recentlyPlayed
        label.textColor = .dynamicWhite
        label.font = Constants.Font.headlineSemibold1
        label.textAlignment = .center
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeViewController.recentlySubtitle
        label.textColor = .dynamicWhite
        label.font = Constants.Font.subtitleSemiBold4
        label.textAlignment = .center
        return label
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    var height: CGFloat = 300 {
        didSet {
            setupSubviewLayout()
        }
    }
    
    private let isUsedCollectionView: Bool
    
    init(isUsedCollectionView: Bool = false) {
        self.isUsedCollectionView = isUsedCollectionView
        super.init(frame: .zero)
        containedShadow = true
        backgroundColor = .dynamicBlack
        
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

// MARK: - Layout
extension HomeContentView {
    private func addSubviews() {
        addSubview(rootFlexContainerView)
    }
    
    private func setupLayout() {
        rootFlexContainerView.flex.alignItems(.center).define { rootView in
            rootView.addItem(titleLabel)
                .marginTop(24.0)
            rootView.addItem(subTitleLabel)
                .marginTop(8.0)
            rootView.addItem(buttonStackView)
                .marginTop(8.0)
            if self.isUsedCollectionView {
                rootView.addItem(collectionView)
                    .height(self.height/2)
                    .marginTop(24.0)
                    .marginBottom(24.0)
            }
        }
    }
    
    private func setupSubviewLayout() {
        pin.height(self.height)
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
        if self.isUsedCollectionView {
            collectionView.pin.left().right()
        }
    }
}
