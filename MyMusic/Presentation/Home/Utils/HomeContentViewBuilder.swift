//
//  HomeContentViewBuilder.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeContentViewBuilder {
    func reset()
    func set(title: String)
    func set(subTitle: String)
    func set(buttons: [UIButton])
    func set(titleColor: UIColor)
    func set(subtitleColor: UIColor)
    func set(backgroundColor: UIColor)
    func set(borderWidth: CGFloat)
    func set(borderColor: CGColor)
    func set(height: CGFloat)
    func make() -> HomeContentView
}

final class DefaultHomeContentViewBuilder: HomeContentViewBuilder {
    private var homeContentView: HomeContentView = {
        let view = HomeContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension DefaultHomeContentViewBuilder {
    func reset() {
        self.homeContentView = {
            let view = HomeContentView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    }
    
    func set(title: String) {
        homeContentView.titleLabel.text = title
    }
    
    func set(subTitle: String) {
        homeContentView.subTitleLabel.text = subTitle
    }
    
    func set(buttons: [UIButton]) {
        buttons.forEach { button in
            homeContentView.buttonStackView.addArrangedSubview(button)
        }
    }
    
    func set(titleColor color: UIColor) {
        homeContentView.titleLabel.textColor = color
    }
    
    func set(subtitleColor color: UIColor) {
        homeContentView.subTitleLabel.textColor = color
    }
    
    func set(backgroundColor color: UIColor) {
        homeContentView.backgroundColor = color
    }
    
    func set(borderWidth width: CGFloat) {
        homeContentView.layer.borderWidth = width
    }
    
    func set(borderColor color: CGColor) {
        homeContentView.layer.borderColor = color
    }
    
    func set(height: CGFloat) {
        homeContentView.height = height
    }
    
    func make() -> HomeContentView {
        let homeContentView = self.homeContentView
        reset()
        return homeContentView
    }
}
