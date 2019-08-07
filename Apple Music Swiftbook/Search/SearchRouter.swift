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
  
  // MARK: Routing
    func routeToPlayerDetaisViewController(cellViewModel: SearchViewModel.Cell) {
        
        let window = UIApplication.shared.keyWindow
//        let playerDetailsView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
        let playerDetailsView: PlayerDetailsView = PlayerDetailsView.loadFromNib()
        playerDetailsView.delegate = viewController
        playerDetailsView.set(viewModel: cellViewModel)
        playerDetailsView.frame = UIScreen.main.bounds
        window?.addSubview(playerDetailsView)
        
    }
  
}
