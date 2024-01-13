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

final class HomeAdapter: NSObject {
    private let recentlyCollectionView: UICollectionView
    weak var recentlyCollectionViewDataSource: HomeRecentlyCollectionViewDataSource?
    weak var recentlyCollectionViewDelegate: HomeRecentlyCollectionViewDelegate?
    
    init(recentlyCollectionView: UICollectionView,
         recentlyCollectionViewDataSource: HomeRecentlyCollectionViewDataSource,
         recentlyCollectionViewDelegate: HomeRecentlyCollectionViewDelegate) {
        recentlyCollectionView.register(RecentlyPlayedCell.self, forCellWithReuseIdentifier: RecentlyPlayedCell.reuseIdentifier)
        
        self.recentlyCollectionView = recentlyCollectionView
        self.recentlyCollectionViewDataSource = recentlyCollectionViewDataSource
        self.recentlyCollectionViewDelegate = recentlyCollectionViewDelegate
        super.init()
        recentlyCollectionView.dataSource = self
        recentlyCollectionView.delegate = self
    }
}

extension HomeAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recentlyCollectionView {
            return recentlyCollectionViewDataSource?.numberOfItems() ?? 0
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recentlyCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyPlayedCell.reuseIdentifier, for: indexPath) as? RecentlyPlayedCell else { return .init() }
            guard let cellData = recentlyCollectionViewDataSource?.cellForItem(at: indexPath.item) else { return cell }
            cell.set(artwork: cellData.artwork)
            return cell
        }
        return .init()
    }
}

extension HomeAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recentlyCollectionView {
            recentlyCollectionViewDelegate?.didSelectItem(at: indexPath.item)
        }
    }
}

extension HomeAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recentlyCollectionView {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == recentlyCollectionView {
            return 8
        }
        return 0
    }
}
