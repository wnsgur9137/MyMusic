//
//  HomeViewController.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeViewControllerDependencies {
    func makePermissionViewController()
}

final class HomeViewController: UIViewController {
    
    private let navigationView: NavigationView = {
        let navigationView = NavigationView(title: "Home")
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.backgroundColor = .clear
        return navigationView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recentlyPlayedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let recentlyPlayedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.HomeViewController.recentlyPlayed
        label.font = Constants.Font.subtitleSemiBold1
        label.textAlignment = .center
        return label
    }()
    
    private let recnetlyPlayedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var viewModel: HomeViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func loadView() {
        super.loadView()
        viewModel?.recentlyPlayed
            .drive{ response in
                print(response)
            }
            .disposed(by: disposeBag)
        
        viewModel?.musicAuth
            .drive { isAuthorized in
                guard !isAuthorized else { return }
                let useCase = DefaultMusicUseCase()
                let viewModel = DefaultPermissionViewModel(musicUseCase: useCase)
                let viewController = PermissionViewController(with: viewModel)
                self.present(viewController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        viewModel?.requestPermission(rx.viewDidLoad)
        viewModel?.viewDidLoad(rx.viewDidLoad)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addSubviews()
        setupLayoutConstraints()
    }
}

// MARK: - Layout
extension HomeViewController {
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            recentlyPlayedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recentlyPlayedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            recentlyPlayedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            recentlyPlayedLabel.centerXAnchor.constraint(equalTo: recentlyPlayedView.centerXAnchor),
            recentlyPlayedLabel.topAnchor.constraint(equalTo: recentlyPlayedView.topAnchor, constant: 8.0),
        ])
    }
}

// MARK: - Add subviews
extension HomeViewController {
    private func addSubviews() {
        view.addSubview(navigationView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(recentlyPlayedView)
        recentlyPlayedView.addSubview(recentlyPlayedLabel)
    }
    
}

#if DEBUG
import SwiftUI
struct Preview: PreviewProvider {
    static var previews: some View {
        HomeViewController().toPreview()
    }
}
#endif
