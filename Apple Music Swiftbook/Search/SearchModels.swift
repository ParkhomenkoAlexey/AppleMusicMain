//
//  SearchModels.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 04/08/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTracks(searchTerm: String)
        
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(searchResults: SearchResults?)
        case presentFooterLoader
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(searchViewModel: SearchViewModel)
        case displayFooterLoader
      }
    }
  }
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var artistName: String
        var collectionName: String
        let previewUrl: String?
    }
    
    let cells: [Cell]
}
