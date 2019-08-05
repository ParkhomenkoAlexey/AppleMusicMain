//
//  SearchInteractor.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 04/08/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    var networkService = NetworkService()
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTracks(let searchTerm):
            print(".getTracks interactor")
            networkService.fetchTracks(searchText: searchTerm) { [weak self] (searchResults) in
                self?.presenter?.presentData(response: .presentTracks(searchResults: searchResults))
            }
        }
    }
}
