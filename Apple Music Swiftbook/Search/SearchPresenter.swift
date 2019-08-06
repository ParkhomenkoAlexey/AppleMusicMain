//
//  SearchPresenter.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 04/08/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?
    
    func presentData(response: Search.Model.Response.ResponseType) {
        
        switch response {
        case .presentTracks(let searchResults):
            let cells = searchResults?.results.map({ (track) in
                cellViewModel(from: track)
            }) ?? []
            let feedViewModel = SearchViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayTracks(searchViewModel: feedViewModel))
            
        }
    }
    
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
//        print("track.trackViewUrl: \(track.trackViewUrl)\ntrack.previewUrl: \(track.previewUrl)\ntrack.feedUrl: \(track.feedUrl)")
        return SearchViewModel.Cell.init(iconUrlString: track.artworkUrl100,
                                         trackName: track.trackName,
                                         artistName: track.artistName,
                                         collectionName: track.collectionName ?? "no collection",
                                         previewUrl: track.previewUrl)
    }
}
