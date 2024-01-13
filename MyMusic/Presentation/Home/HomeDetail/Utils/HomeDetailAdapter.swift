//
//  HomeDetailAdapter.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/14/24.
//

import UIKit
import MusicKit

protocol HomeDetailTableViewDataSource: AnyObject {
    func numberOfRows() -> Int
    func cellForRow(at index: Int) -> String
}

protocol HomeDetailTableViewDelegate: AnyObject {
    func didSelectRow(at index: Int)
}

final class HomeDetailAdapter: NSObject {
    private let tableView: UITableView
    weak var datasource: HomeDetailTableViewDataSource?
    weak var delegate: HomeDetailTableViewDelegate?
    
    init(tableView: UITableView, 
         datasource: HomeDetailTableViewDataSource?,
         delegate: HomeDetailTableViewDelegate?) {
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.reuseIdentifier)
        
        self.tableView = tableView
        self.datasource = datasource
        self.delegate = delegate
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension HomeDetailAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.reuseIdentifier, for: indexPath) as? SongTableViewCell else { return .init() }
        guard let title = self.datasource?.cellForRow(at: indexPath.row) else { return cell }
        cell.set(title: title)
        return cell
    }
}

extension HomeDetailAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectRow(at: indexPath.row)
    }
}
