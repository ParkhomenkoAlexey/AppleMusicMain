//
//  MusicSearchController.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 17/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit
import Alamofire

class MusicSearchController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var networkService = NetworkService()
    
    fileprivate var timer: Timer?
    
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName ?? "")\n\(track.artistName ?? "")"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension MusicSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkService.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
            }
        })
    }
}



