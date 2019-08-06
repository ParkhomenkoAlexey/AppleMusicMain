//
//  PlayerDetailsView.swift
//  PodcastsCourseLBTA
//
//  Created by Алексей Пархоменко on 06/08/2019.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

class PlayerDetailsView: UIView {
    
//    var episode: Episode! {
//        didSet {
//            episodeTitleLabel.text = episode.title
//            guard let url = URL(string: episode.imageUrl ?? "") else { return }
//            episodeImageView.sd_setImage(with: url, completed: nil)
//        }
//    }
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    
    @IBAction func PlayerDetailsView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        episodeTitleLabel.text = viewModel.trackName
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        episodeImageView.sd_setImage(with: url, completed: nil)
    }
    
}
