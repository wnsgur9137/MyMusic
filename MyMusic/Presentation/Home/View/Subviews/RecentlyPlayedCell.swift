//
//  RecentlyPlayedCell.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import UIKit
import MusicKit
import Kingfisher
import SkeletonView
import FlexLayout

final class RecentlyPlayedCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.isSkeletonable = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        imageView.showSkeleton()
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        imageView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]), animation: skeletonAnimation)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSubviewLayout()
    }
}

extension RecentlyPlayedCell {
    func set(artwork: Artwork?) {
        guard let url = artwork?.url(width: 200, height: 200) else { return }
        imageView.kf.setImage(with: url, completionHandler: { [weak self] _ in
            self?.imageView.stopSkeletonAnimation()
            self?.imageView.hideSkeleton()
        })
    }
}

// MARK: - Layout
extension RecentlyPlayedCell {
    private func addSubviews() {
        addSubview(imageView)
    }
    
    private func setupSubviewLayout() {
        imageView.pin.all()
    }
}
