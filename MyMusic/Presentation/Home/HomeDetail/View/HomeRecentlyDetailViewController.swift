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

final class HomeRecentlyDetailViewController: UIViewController {
    
    private let navigationView: NavigationView = {
        let view = NavigationView(title: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.backwardButton.isHidden = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainView: HomeDetailView = {
        let view = HomeDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        setupLayoutConstraints()
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
    func setupLayoutConstraints() {
        scrollView.addPaddingTop(height: 56.0)
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

// MARK: - Add subviews
extension HomeRecentlyDetailViewController {
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        
        view.addSubview(navigationView)
    }
}