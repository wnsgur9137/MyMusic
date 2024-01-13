//
//  PermissionViewController.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PermissionViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.permissionBackground
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.PermissionViewController.title
        label.textColor = .dynamicBlack
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0.2, height: 0.2)
        label.font = Constants.Font.headlineBold1
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.PermissionViewController.subTitle
        label.textColor = .dynamicBlack
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 0.2, height: 0.2)
        label.font = Constants.Font.subtitleSemiBold2
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let titleView: UIView = {
        let stackView = UIView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let permissionButton: CustomButton = {
        let button = CustomButton(style: .fill, size: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("권한 요청하기", for: .normal)
        button.setTitleColor(.dynamicBlack, for: .normal)
        return button
    }()
    
    private let viewModel: PermissionViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    static func create(viewModel: PermissionViewModel) -> PermissionViewController {
        let viewController = PermissionViewController(with: viewModel)
        return viewController
    }
    
    init(with viewModel: PermissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupGradientBackground() // 아무리 해봐도 안이뻐서 그냥 이미지로 대체...
        
        addSubviews()
        setupLayoutConstraints()
        
        setupPermissionButtonAction()
    }
    
    private func setupPermissionButtonAction() {
        permissionButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.requestMusicAuthorization()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupGradientBackground() {
//        let darkBlue = UIColor(red: 26/255, green: 35/255, blue: 126/255, alpha: 1.0)
        let white = UIColor.white
        let lightBlue = UIColor(red: 72/255, green: 133/255, blue: 237/255, alpha: 1.0)
        let colors: [CGColor] = [white.cgColor, lightBlue.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0.3, 0.5]
        
        view.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Bind
extension PermissionViewController {
    private func bind() {
        viewModel.musicAuth
            .drive(onNext: { [weak self] isAuth in
                if isAuth {
                    self?.dismiss(animated: true)
                } else {
                    guard let self = self else { return }
                    let alertBuilder = DefaultAlertBuilder()
                    alertBuilder.set(alertType: .horizontalButton)
                    alertBuilder.set(title: Constants.PermissionViewController.authAlertTitle)
                    alertBuilder.set(message: Constants.PermissionViewController.authAlertMessage)
                    alertBuilder.set(messageAlignment: .center)
                    alertBuilder.set(confirmTitle: Constants.PermissionViewController.authAlertConfirm)
                    if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                        alertBuilder.add(confirmAction: {
                            UIApplication.shared.open(settingURL)
                        })
                    }
                    alertBuilder.build(self)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension PermissionViewController {
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleView.topAnchor.constraint(equalTo: view.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: titleView.centerYAnchor, constant: -6.0),
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 6.0),
            subtitleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            
            permissionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            permissionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Add subview
extension PermissionViewController {
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        view.addSubview(permissionButton)
    }
}
