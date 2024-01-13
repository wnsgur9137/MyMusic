//
//  HomeViewController.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

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
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let recentlyPlayedView: HomeContentView = {
        let builder: HomeContentViewBuilder = DefaultHomeContentViewBuilder()
        builder.set(title: Constants.HomeViewController.recentlyPlayed)
        builder.set(titleColor: .dynamicWhite)
        builder.set(subTitle: Constants.HomeViewController.recentlySubtitle)
        builder.set(subtitleColor: .dynamicWhite)
        builder.set(backgroundColor: .dynamicBlack)
        builder.set(height: 300)
        return builder.make()
    }()
    
    private let recentlyPlayedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    private var viewModel: HomeViewModel
    private let homeContentViewBuilder: HomeContentViewBuilder = DefaultHomeContentViewBuilder()
    private let disposeBag = DisposeBag()
    private var adapter: HomeAdapter?
    
    // MARK: - Life cycle
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let viewController = HomeViewController(with: viewModel)
        return viewController
    }
    
    init(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.adapter = HomeAdapter(
            recentlyCollectionView: self.recentlyPlayedCollectionView,
            recentlyCollectionViewDataSource: viewModel,
            recentlyCollectionViewDelegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        viewModel.recentlyPlayed
            .drive{ response in
                print(response)
            }
            .disposed(by: disposeBag)
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupRecentlyPlayedView()
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    private func setupRecentlyPlayedView() {
        
    }
}

extension HomeViewController: HomeRecentlyCollectionViewDelegate {
    func didSelectItem(at index: Int) {
        print("index: \(index)")
    }
}

// MARK: - Bind
extension HomeViewController {
    private func bind() {
        viewModel.requestPermission(rx.viewDidLoad)
        viewModel.viewDidLoad(rx.viewDidLoad)
        viewModel.viewWillAppear(rx.viewWillAppear)
        
        viewModel.loadedPlayedMusicItemDriver
            .drive(onNext: { [weak self] _ in
                self?.recentlyPlayedCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout
extension HomeViewController {
    private func setupLayoutConstraints() {
        scrollView.addPaddingTop(height: 56.0)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            recentlyPlayedCollectionView.leadingAnchor.constraint(equalTo: recentlyPlayedView.leadingAnchor),
            recentlyPlayedCollectionView.topAnchor.constraint(equalTo: recentlyPlayedView.centerYAnchor, constant: -30.0),
            recentlyPlayedCollectionView.trailingAnchor.constraint(equalTo: recentlyPlayedView.trailingAnchor),
            recentlyPlayedCollectionView.bottomAnchor.constraint(equalTo: recentlyPlayedView.bottomAnchor, constant: -24.0),
            
            contentView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
}

// MARK: - Add subviews
extension HomeViewController {
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(recentlyPlayedView)
        recentlyPlayedView.addSubview(recentlyPlayedCollectionView)
        
        view.addSubview(navigationView)
    }
}

#if DEBUG
//import SwiftUI
//struct Preview: PreviewProvider {
//    static var previews: some View {
//        HomeViewController().toPreview()
//    }
//}
#endif
