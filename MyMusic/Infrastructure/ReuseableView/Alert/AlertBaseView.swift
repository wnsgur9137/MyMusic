//
//  AlertBaseView.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/12/24.
//

import UIKit
import RxCocoa

class AlertBaseView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = Constants.Font.headlineBold2
        label.textAlignment = .center
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Font.body5
        label.text = "testTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTesttestTest"
        return label
    }()
    
    let confirmButton: CustomButton = {
        let button = CustomButton(style: .fill, size: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonTitle = "확인"
        return button
    }()
    
    let cancelButton: CustomButton = {
        let button = CustomButton(style: .outline, size: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.buttonTitle = "취소"
        return button
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25.0
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var checkboxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        return stackView
    }()
    
    lazy var isCheckedCheckboxs: [Bool] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .dynamicWhite
        layer.cornerRadius = 24.0
        layer.applySketchShadow(color: .dynamicBlack,
                                alpha: 0.06,
                                width: 6,
                                height: 6,
                                blur: 15,
                                spread: 0)
        
        setupDefaultLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlertBaseView {
    func setupCheckboxViews(_ views: [UIView]) {
        let lastIndex = contentStackView.arrangedSubviews.endIndex
        views.forEach { checkboxStackView.addArrangedSubview($0) }
        contentStackView.insertArrangedSubview(checkboxStackView, at: lastIndex - 1)
    }
    
    func setupImage(name: String){
        guard let image = UIImage(named: name) else { return }
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentStackView.topAnchor)
        ])
    }
    
    func configure(buttonAxis axis: NSLayoutConstraint.Axis) {
        buttonStackView.axis = axis
    }
    
    func removeCancelButton() {
        buttonStackView.removeArrangedSubview(cancelButton)
        cancelButton.removeFromSuperview()
    }
}

// MARK: - Layout
extension AlertBaseView {
    func setupDefaultLayout(){
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(messageLabel)
        
        buttonStackView.addArrangedSubview(confirmButton)
        buttonStackView.addArrangedSubview(cancelButton)
        
        contentStackView.addArrangedSubview(labelStackView)
        contentStackView.addArrangedSubview(buttonStackView)
        self.addSubview(contentStackView)
        
        self.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: -24.0).isActive = true
        self.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: -32.0).isActive = true
        self.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: 24.0).isActive = true
        self.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 24.0).isActive = true
        
        confirmButton.heightAnchor.constraint(equalToConstant: ButtonSize.large.buttonHeight).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: ButtonSize.large.buttonHeight).isActive = true
    }
}
