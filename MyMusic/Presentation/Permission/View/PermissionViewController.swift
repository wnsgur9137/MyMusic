//
//  PermissionViewController.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/11/24.
//

import UIKit

final class PermissionViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let permissionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("teststestest", for: .normal)
        return button
    }()
    
    private let viewModel: PermissionViewModel
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupLayoutConstraints()
        
        setupPermissionButtonAction()
    }
    
    private func setupPermissionButtonAction() {
        permissionButton.addAction(
            UIAction { _ in
                self.viewModel.requestMusicAuthorization()
            },
            for: .touchUpInside
        )
    }
}

// MARK: - Layout
extension PermissionViewController {
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            permissionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            permissionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Add subview
extension PermissionViewController {
    private func addSubviews() {
        view.addSubview(permissionButton)
    }
}
