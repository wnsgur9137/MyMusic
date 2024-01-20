//
//  HomeDetailView.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/14/24.
//

import UIKit
import FlexLayout
import PinLayout

final class HomeDetailView: UIView {
    
    private let rootFlexContainerView = UIView()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12.0
        imageView.containedShadow = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let albumLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeDetailView.album
        label.numberOfLines = 0
        label.textColor = .dynamicBlack
        label.font = Constants.Font.headlineBold2
        label.textAlignment = .center
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomeDetailView.artist
        label.textColor = .dynamicBlack
        label.font = Constants.Font.subtitleSemiBold3
        return label
    }()
    
    private let playButton: CustomButton = {
        let button = CustomButton(style: .outline, size: .medium)
        button.setTitle("재생", for: .normal)
        return button
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.SongTableViewCell.track
        label.textColor = .dynamicBlack
        label.font = Constants.Font.subtitleSemiBold2
        return label
    }()
    
    let trackTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
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

extension HomeDetailView {
    
    func set(albumTitle: String) {
        albumLabel.text = albumTitle
    }
    
    func set(artistName: String) {
        artistLabel.text = artistName
    }
}

// MARK: - Layout
extension HomeDetailView {
    func addSubviews() {
        addSubview(rootFlexContainerView)
    }
    
    func setupLayout() {
        rootFlexContainerView.flex
            .alignItems(.center)
            .define { flex in
                let imageWidth = (UIScreen.main.bounds.width / 5) * 4
                flex.addItem(imageView)
                    .marginTop(56)
                    .width(imageWidth)
                    .height(imageWidth)
                
                flex.addItem(albumLabel)
                    .marginTop(12.0)
                
                flex.addItem(artistLabel)
                    .marginTop(8.0)
                
                flex.addItem(trackLabel)
                    .alignSelf(.start)
                    .margin(24.0, 24.0, 0, 24.0)
                
                flex.addItem(trackTableView)
                    .marginTop(8.0)
                    .width(100%)
        }
    }
    
    func setupSubviewLayout() {
        rootFlexContainerView.pin.all(self.pin.safeArea)
        rootFlexContainerView.flex.layout()
    }
}
