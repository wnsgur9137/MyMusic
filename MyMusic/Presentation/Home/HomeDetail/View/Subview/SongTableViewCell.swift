//
//  SongTableViewCell.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/14/24.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.SongTableViewCell.title
        label.textColor = .dynamicBlack
        label.font = Constants.Font.body5
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 12.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
}
