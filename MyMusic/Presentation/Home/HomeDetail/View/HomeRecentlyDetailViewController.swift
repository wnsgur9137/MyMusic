//
//  HomeRecentlyDetailViewController.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import MusicKit
import Kingfisher
import FlexLayout

final class HomeRecentlyDetailViewController: UIViewController {
    
    private let navigationView: NavigationView = {
        let view = NavigationView(title: "")
        view.backgroundColor = .clear
        view.backwardButton.isHidden = false
        return view
    }()
    private let mainView = HomeDetailView()
    
    private let viewModel: HomeRecentlyDetailViewModel
    private let disposeBag = DisposeBag()
    private var adapter: HomeDetailAdapter?
    
    // MARK: - Life cycle
    
    static func create(with viewModel: HomeRecentlyDetailViewModel) -> HomeRecentlyDetailViewController {
        let viewController = HomeRecentlyDetailViewController(with: viewModel)
        return viewController
    }
    
    init(with viewModel: HomeRecentlyDetailViewModel) {
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
        view.backgroundColor = .background
        
        self.adapter = HomeDetailAdapter(tableView: mainView.trackTableView,
                                         datasource: viewModel,
                                         delegate: self)
        setupBackwardButton()
        
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubviewLayout()
    }
    
    private func setupBackwardButton() {
        navigationView.backwardButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind
extension HomeRecentlyDetailViewController {
    private func bind() {
        viewModel.viewDidLoad(rx.viewDidLoad)
        
        viewModel.albumTitleDriver
            .drive(onNext: { [weak self] albumTitle in
                self?.mainView.set(albumTitle: albumTitle)
                self?.navigationView.configure(title: albumTitle)
            })
            .disposed(by: disposeBag)
        
        viewModel.artistDriver
            .drive(onNext: { [weak self] artistName in
                self?.mainView.set(artistName: artistName)
            })
            .disposed(by: disposeBag)
        
        viewModel.imageDriver
            .drive(onNext: { [weak self] url in
                self?.mainView.imageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.trackDriver
            .drive(onNext: { [weak self] _ in
                self?.mainView.trackTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - HomeDetailTableView Delegate
extension HomeRecentlyDetailViewController: HomeDetailTableViewDelegate {
    func didSelectRow(at index: Int) {
        viewModel.didSelectTrack(at: index)
    }
}

// MARK: - Layout
extension HomeRecentlyDetailViewController {
    private func setupSubviewLayout() {
        navigationView.pin
            .left()
            .top()
            .right()
        navigationView.flex.layout()
        
        mainView.pin.all()
        mainView.flex.layout()
    }
}

// MARK: - Add subviews
extension HomeRecentlyDetailViewController {
    func addSubviews() {
        view.addSubview(mainView)
        view.addSubview(navigationView)
    }
}
