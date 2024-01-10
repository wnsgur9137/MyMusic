//
//  HomeViewController.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let navigationView: NavigationView = {
        let navigationView = NavigationView(title: "Home")
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        return navigationView
    }()
    
    private let recentlyPlayedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recentlyPlayedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.HomeViewController.recentlyPlayed
        label.font = Constants.Font.subtitleSemiBold1
        return label
    }()
    
    private let recnetlyPlayedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var viewModel: HomeViewModel?
    
    // MARK: - Life cycle
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .background
        addSubviews()
        setupLayoutConstraints()
    }
}

// MARK: - Layout
extension HomeViewController {
    private func addSubviews() {
        view.addSubview(navigationView)
        view.addSubview(recentlyPlayedView)
        recentlyPlayedView.addSubview(recentlyPlayedLabel)
    }
}

// MARK: - Add subviews
extension HomeViewController {
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            recentlyPlayedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
            recentlyPlayedView.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 24.0),
            recentlyPlayedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
        ])
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
