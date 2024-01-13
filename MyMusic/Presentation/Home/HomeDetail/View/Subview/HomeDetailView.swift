//
//  HomeDetailView.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/14/24.
//

import UIKit

final class HomeDetailView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12.0
        imageView.containedShadow = true
        imageView.clipsToBounds = true
        
        let imageViewWidth = (UIScreen.main.bounds.width / 5) * 4
        imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        return imageView
    }()
    
    private let albumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.HomeDetailView.album
        label.numberOfLines = 0
        label.textColor = .dynamicBlack
        label.font = Constants.Font.headlineBold2
        label.textAlignment = .center
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.SongTableViewCell.track
        label.textColor = .dynamicBlack
        label.font = Constants.Font.subtitleSemiBold2
        return label
    }()
    
    let trackTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 24.0),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            albumLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12.0),
            albumLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            albumLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            albumLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            artistLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 8.0),
            artistLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            trackLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
            trackLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 24.0),
            
            trackTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackTableView.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: 8.0),
            trackTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Add subviews
extension HomeDetailView {
    func addSubviews() {
        addSubview(imageView)
        addSubview(albumLabel)
        addSubview(artistLabel)
        addSubview(trackLabel)
        addSubview(trackTableView)
    }
}
