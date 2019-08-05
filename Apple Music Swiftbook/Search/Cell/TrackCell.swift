//
//  TrackCell.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 05/08/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    override func prepareForReuse() {
        trackImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.layer.borderWidth = 0.1
        trackImageView.layer.borderColor = #colorLiteral(red: 0.5667956471, green: 0.5676371455, blue: 0.5925787091, alpha: 1)
        trackImageView.layer.cornerRadius = 3
    }
    
    func set(viewModel: TrackCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
}
