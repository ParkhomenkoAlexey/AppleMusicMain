//
//  PlayerDetailsView.swift
//  PodcastsCourseLBTA
//
//  Created by Алексей Пархоменко on 06/08/2019.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

class PlayerDetailsView: UIView {
    
    @IBOutlet weak var trackTitleLabel: UILabel! {
        didSet {
            trackTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var authorTitleLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func PlayerDetailsView(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
}
