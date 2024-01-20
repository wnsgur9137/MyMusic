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
import FlexLayout
import PinLayout

final class HomeViewController: UIViewController {
    
    private let navigationView: NavigationView = {
        let navigationView = NavigationView(title: "Home")
        navigationView.backgroundColor = .clear
        return navigationView
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let recommendStackView = UIView()
    
    private let recentlyPlayedView: HomeContentView = {
        let builder: HomeContentViewBuilder = DefaultHomeContentViewBuilder(isUsedCollectionView: true)
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
            recentlyCollectionView: recentlyPlayedView.collectionView,
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
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    private func makeRecommendView(titles: [String]) {
        let builder: HomeContentViewBuilder = DefaultHomeContentViewBuilder(isUsedCollectionView: true)
        for (index, title) in titles.enumerated() {
            builder.set(title: title)
            builder.set(titleColor: .dynamicBlack)
            builder.set(subTitle: Constants.HomeViewController.recommendSubitlte)
            builder.set(subtitleColor: .dynamicBlack)
            builder.set(backgroundColor: .dynamicWhite)
            
            let seeMoreButton = makeRecommendButton(index: index)
            builder.set(buttons: [seeMoreButton])
            
            let view = builder.make()
            builder.reset()
            view.collectionView.tag = index
            self.adapter?.add(view.collectionView)
            
            recommendStackView.flex.addItem(view)
                .marginTop(16)
                .height(300)
        }
        updateScrollViewLayout()
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
}

// MARK: - Bind
extension HomeViewController {
    private func bind() {
        viewModel.requestPermission(rx.viewDidLoad)
        viewModel.viewDidLoad(rx.viewDidLoad)
        viewModel.viewWillAppear(rx.viewWillAppear)
        
        viewModel.loadedPlayedMusicItemDriver
            .drive(onNext: { [weak self] _ in
                self?.recentlyPlayedView.collectionView.reloadData()
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
    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(navigationView)
    }
    
    private func setupLayout() {
        scrollView.flex.define { scrollView in
            scrollView.addItem(contentView).define { contentView in
                contentView.addItem(recentlyPlayedView)
                    .marginTop(56)
                    .width(100%)
                contentView.addItem(recommendStackView)
                    .marginTop(16.0)
            }
        }
    }
    
    private func setupSubviewLayout() {
        navigationView.pin
            .left()
            .top()
            .right()
        navigationView.flex.layout()
        
        scrollView.pin.all()
        scrollView.flex.layout()
        contentView.flex.layout()
        recommendStackView.flex.layout()
        
        scrollView.contentSize = contentView.frame.size
    }
    
    private func updateScrollViewLayout() {
        scrollView.flex.layout()
        contentView.flex.layout()
        recommendStackView.flex.layout()
        scrollView.contentSize = contentView.frame.size
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
