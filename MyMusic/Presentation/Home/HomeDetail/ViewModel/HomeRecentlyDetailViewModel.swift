//
//  HomeRecentlyDetailViewModel.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa
import MusicKit

protocol HomeRecentlyDetailViewModelInput {
    func viewDidLoad(_ observable: Observable<Void>)
    func didSelectTrack(at index: Int)
}

protocol HomeRecentlyDetailViewModelOutput {
    var imageDriver: Driver<URL> { get }
    var albumTitleDriver: Driver<String> { get }
    var artistDriver: Driver<String> { get }
    var trackDriver: Driver<MusicItemCollection<Track>> { get }
}

protocol HomeRecentlyDetailViewModel: HomeRecentlyDetailViewModelInput,
                                      HomeRecentlyDetailViewModelOutput,
                                      HomeDetailTableViewDataSource { }

final class DefaultHomeRecentlyDetailViewModel: HomeRecentlyDetailViewModel {
    
    private let disposeBag = DisposeBag()
    private let albumInfo: RecentlyPlayedMusicItem
    
    private let albumTitleRelay: PublishRelay<String> = .init()
    var albumTitleDriver: Driver<String> {
        return albumTitleRelay.asDriver(onErrorDriveWith: .never())
    }
    
    private let artistRelay: PublishRelay<String> = .init()
    var artistDriver: Driver<String> {
        return artistRelay.asDriver(onErrorDriveWith: .never())
    }
    
    private let imageRelay: PublishRelay<URL> = .init()
    var imageDriver: Driver<URL> {
        return imageRelay.asDriver(onErrorDriveWith: .never())
    }
    
    private var tracks: MusicItemCollection<Track> = []
    private let trackRelay: PublishRelay<MusicItemCollection<Track>> = .init()
    var trackDriver: Driver<MusicItemCollection<Track>> {
        return trackRelay.asDriver(onErrorDriveWith: .never())
    }
    
    init(item: RecentlyPlayedMusicItem) {
        self.albumInfo = item
    }
    
    private func load(albumTitle: String) {
        albumTitleRelay.accept(albumTitle)
    }
    
    private func load(artist: String) {
        artistRelay.accept(artist)
    }
    
    private func load(imageURL: URL) {
        imageRelay.accept(imageURL)
    }
    
    private func load(tracks: MusicItemCollection<Track>?) {
        guard let tracks = tracks else { return }
        self.tracks = tracks
        trackRelay.accept(self.tracks)
    }
}

extension DefaultHomeRecentlyDetailViewModel {
    func viewDidLoad(_ viewDidLoad: Observable<Void>) {
        viewDidLoad
            .subscribe(onNext: {
                if let url = self.albumInfo.artwork?.url(width: 500, height: 500) {
                    self.load(imageURL: url)
                }
                self.load(albumTitle: self.albumInfo.title)
                
                switch self.albumInfo {
                case .album(let album):
                    self.load(artist: album.artistName)
                    self.load(tracks: album.tracks)
                case .playlist(let playlist):
                    self.load(artist: playlist.curatorName ?? "")
                    self.load(tracks: playlist.tracks)
                case .station(let station):
                    self.load(artist: station.description)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func didSelectTrack(at index: Int) {
        
    }
}

// MARK: - HomeDetailTableView DataSource
extension DefaultHomeRecentlyDetailViewModel: HomeDetailTableViewDataSource {
    func numberOfRows() -> Int {
        return self.tracks.count
    }
    
    func cellForRow(at index: Int) -> String {
        return tracks[index].title
    }
}
