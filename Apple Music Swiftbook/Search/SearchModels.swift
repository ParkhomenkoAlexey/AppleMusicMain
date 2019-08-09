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
    class Cell: TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var artistName: String
        var collectionName: String
        let previewUrl: String?
        

        init(iconUrlString: String?,
             trackName: String,
             artistName: String,
             collectionName: String,
             previewUrl: String?) {
            self.iconUrlString = iconUrlString
            self.trackName = trackName
            self.artistName = artistName
            self.collectionName = collectionName
            self.previewUrl = previewUrl
        }
        
    }
    
    let cells: [Cell]
}
