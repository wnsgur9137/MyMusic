//
//  SongTableViewCell.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/14/24.
//

import UIKit
import FlexLayout
import PinLayout

final class SongTableViewCell: UITableViewCell {
    private let rootFlexContainerView = UIView()
    
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
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout
extension SongTableViewCell {
    private func setupLayout() {
        addSubview(rootFlexContainerView)
        
        rootFlexContainerView.flex.define { flex in
            flex.addItem(titleLabel)
                .marginLeft(12.0)
                .marginRight(12.0)
        }
        
        rootFlexContainerView.pin.all()
        rootFlexContainerView.flex.layout()
    }
}
