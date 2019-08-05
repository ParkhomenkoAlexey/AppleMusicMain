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
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
}

struct SearchViewModel {
    struct Cell {
        var iconUrlString: String?
        var trackName: String
        var artistName: String
        var collectionName: String
    }
    
    let cells: [Cell]
}
