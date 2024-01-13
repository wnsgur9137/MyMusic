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
import MusicKit

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
    
    private var recommendCollectionViews: [UICollectionView] = []
    
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
            recentlyCollectionViewDelegate: self,
            recommendCollectionViewDataSource: viewModel,
            recommendCollectionViewDelegate: self)
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
        view.backgroundColor = .background
        
        addSubviews()
        setupLayoutConstraints()
    }
    
    private func makeRecommendView(titles: [String]) {
        let builder: HomeContentViewBuilder = DefaultHomeContentViewBuilder()
        for (index, title) in titles.enumerated() {
            builder.set(title: title)
            builder.set(titleColor: .dynamicBlack)
            builder.set(subTitle: Constants.HomeViewController.recommendSubitlte)
            builder.set(subtitleColor: .dynamicBlack)
            builder.set(backgroundColor: .background)
            builder.set(height: 350)
            
            let seeMoreButton = makeRecommendButton(index: index)
            builder.set(buttons: [seeMoreButton])
            
            let view = builder.make()
            builder.reset()
            
            let recommendCollectionView = makeRecommendCollectionView()
            recommendCollectionView.tag = index
            
            view.addSubview(recommendCollectionView)
            recommendCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            recommendCollectionView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -10.0).isActive = true
            recommendCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            recommendCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24.0).isActive = true
            
            self.adapter?.add(recommendCollectionView)
            recommendCollectionViews.append(recommendCollectionView)
            contentStackView.addArrangedSubview(view)
        }
    }
    
    private func makeRecommendButton(index: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(Constants.HomeViewController.seeMore, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = Constants.Font.button2
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didTapRecommendSeemoreButton(at: index)
            })
            .disposed(by: disposeBag)
        return button
    }
    
    private func makeRecommendCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isSkeletonable = true
        return collectionView
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
        
        viewModel.loadedRecommendMusicItemDriver
            .drive(onNext: { [weak self] recommendTitles in
                self?.makeRecommendView(titles: recommendTitles)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - RecentlryCollectionView Delegate
extension HomeViewController: HomeRecentlyCollectionViewDelegate {
    func didSelectItem(at index: Int) {
        viewModel.didSelectRecentlyItem(at: index)
    }
}

// MARK: - RecommendCollectionView Delegate
extension HomeViewController: HomeRecommendCollectionViewDelegate {
    func didSelectItem(tag index: Int, at itemIndex: Int) {
        viewModel.didSelectRecommendItem(tag: index, at: itemIndex)
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
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            recentlyPlayedCollectionView.leadingAnchor.constraint(equalTo: recentlyPlayedView.leadingAnchor),
            recentlyPlayedCollectionView.topAnchor.constraint(equalTo: recentlyPlayedView.centerYAnchor, constant: -10.0),
            recentlyPlayedCollectionView.trailingAnchor.constraint(equalTo: recentlyPlayedView.trailingAnchor),
            recentlyPlayedCollectionView.bottomAnchor.constraint(equalTo: recentlyPlayedView.bottomAnchor, constant: -24.0),
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
