//
//  PodcastResponse.swift
//  PodcastsApp
//
//  Created by Алексей Пархоменко on 07/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    var resultCount: Int
    var results: [Track]
}

class Track: NSObject, Decodable, NSCoding  {
    
    func encode(with coder: NSCoder) {
        coder.encode(trackName, forKey: "trackName")
        coder.encode(artistName, forKey: "artistName")
        coder.encode(collectionName, forKey: "collectionName")
        coder.encode(artworkUrl100, forKey: "artworkUrl100")
        coder.encode(previewUrl, forKey: "previewUrl")
        coder.encode(wrapperType, forKey: "wrapperType")
    }
    
    required init?(coder: NSCoder) {
        wrapperType = coder.decodeObject(forKey: "wrapperType") as? String ?? ""
        trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
        artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
        collectionName = coder.decodeObject(forKey: "collectionName") as? String ?? ""
        artworkUrl100 = coder.decodeObject(forKey: "artworkUrl100") as? String ?? ""
        previewUrl = coder.decodeObject(forKey: "previewUrl") as? String ?? ""
    }
    
    let wrapperType: String
    
    let trackName: String
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
    
    let previewUrl: String?
    
    
    
}


