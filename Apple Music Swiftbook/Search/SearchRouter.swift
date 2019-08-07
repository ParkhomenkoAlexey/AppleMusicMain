//
//  SearchRouter.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 04/08/2019.
//  Copyright (c) 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol SearchRoutingLogic {
    func routeToPlayerDetaisViewController(cellViewModel: SearchViewModel.Cell)

}

class SearchRouter: NSObject, SearchRoutingLogic {
    
  weak var viewController: SearchViewController?
  
  // MARK: - Routing
    
    func routeToPlayerDetaisViewController(cellViewModel: SearchViewModel.Cell) {
        
        viewController?.tabBarDelegate?.maximizePlayerDetails(viewModel: cellViewModel)
    }
}
