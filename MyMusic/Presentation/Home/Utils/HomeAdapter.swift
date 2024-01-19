//
//  HomeAdapter.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import UIKit
import MusicKit

protocol HomeRecentlyCollectionViewDataSource: AnyObject {
    func numberOfItems() -> Int
    func cellForItem(at index: Int) -> RecentlyPlayedMusicItem
}

protocol HomeRecentlyCollectionViewDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

protocol HomeRecommendCollectionViewDataSource: AnyObject {
    func numberOfItems(tag index: Int) -> Int
    func cellForItem(tag index: Int, at itemIndex: Int) -> MusicPersonalRecommendation.Item
}

protocol HomeRecommendCollectionViewDelegate: AnyObject {
    func didSelectItem(tag index: Int, at itemIndex: Int)
}

final class HomeAdapter: NSObject {
    private let recentlyCollectionView: UICollectionView
    weak var recentlyCollectionViewDataSource: HomeRecentlyCollectionViewDataSource?
    weak var recentlyCollectionViewDelegate: HomeRecentlyCollectionViewDelegate?
    weak var recommendCollectionViewDataSource: HomeRecommendCollectionViewDataSource?
    weak var recommendCollectionViewDelegate: HomeRecommendCollectionViewDelegate?
    
    init(recentlyCollectionView: UICollectionView,
         recentlyCollectionViewDataSource: HomeRecentlyCollectionViewDataSource,
         recentlyCollectionViewDelegate: HomeRecentlyCollectionViewDelegate,
         recommendCollectionViewDataSource: HomeRecommendCollectionViewDataSource,
         recommendCollectionViewDelegate: HomeRecommendCollectionViewDelegate) {
        recentlyCollectionView.register(RecentlyPlayedCell.self, forCellWithReuseIdentifier: RecentlyPlayedCell.reuseIdentifier)
        
        self.recentlyCollectionView = recentlyCollectionView
        self.recentlyCollectionViewDataSource = recentlyCollectionViewDataSource
        self.recentlyCollectionViewDelegate = recentlyCollectionViewDelegate
        self.recommendCollectionViewDataSource = recommendCollectionViewDataSource
        self.recommendCollectionViewDelegate = recommendCollectionViewDelegate
        super.init()
        recentlyCollectionView.dataSource = self
        recentlyCollectionView.delegate = self
    }
}

extension HomeAdapter {
    func add(_ collectionView: UICollectionView) {
        collectionView.register(RecentlyPlayedCell.self, forCellWithReuseIdentifier: RecentlyPlayedCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension HomeAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentlyCollectionView {
            return recentlyCollectionViewDataSource?.numberOfItems() ?? 0
        } else {
            let tag = collectionView.tag
            return recommendCollectionViewDataSource?.numberOfItems(tag: tag) ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentlyCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyPlayedCell.reuseIdentifier, for: indexPath) as? RecentlyPlayedCell else { return .init() }
            guard let cellData = recentlyCollectionViewDataSource?.cellForItem(at: indexPath.item) else { return cell }
            cell.set(artwork: cellData.artwork)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyPlayedCell.reuseIdentifier, for: indexPath) as? RecentlyPlayedCell else { return .init() }
            let tag = collectionView.tag
            guard let cellData = recommendCollectionViewDataSource?.cellForItem(tag: tag, at: indexPath.item) else { return cell }
            cell.set(artwork: cellData.artwork)
            return cell
        }
    }
}

extension HomeAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recentlyCollectionView {
            recentlyCollectionViewDelegate?.didSelectItem(at: indexPath.item)
        } else {
            let tag = collectionView.tag
            recommendCollectionViewDelegate?.didSelectItem(tag: tag, at: indexPath.item)
        }
    }
}

extension HomeAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("collectionView.bounds.height: \(collectionView.bounds.height)")
        return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
