//
//  NetworkService.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 20/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    
    private var jsonResponse: Any?
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResults?) -> Void) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText,
                          "media": "music",
                          "limit": "10",
                          "entity": "musicTrack"] // "entity": "musicArtist, musicTrack, album"
     
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            let decoder = JSONDecoder()
            do {
                
                self.jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
                guard let jsonResponse = self.jsonResponse as? [String: Any],
                    let results = jsonResponse["results"] as? [Any] else {
                        completion(nil)
                        return
                }
                            print(results)
                
                let objects = try decoder.decode(SearchResults.self, from: data)
//                print("objects:\(objects)")
                completion(objects)
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                completion(nil)
            }
        }
    }
    
    
}


