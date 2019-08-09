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
    var viewModel: TrackCellViewModel!
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackButton: UIButton!
    
    
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
        self.viewModel = viewModel
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    
    @IBAction func addTrack(_ sender: Any) {
        print("123")
        let defaults = UserDefaults.standard
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: viewModel, requiringSecureCoding: false) {
            
            defaults.set(savedData, forKey: "LibraryTracks")
            print("success!")
        }
        let savedTrack = defaults.object(forKey: "LibraryTracks") as? TrackCellViewModel ?? nil
        print(savedTrack)
        
//        let defaults = UserDefaults.standard
//        defaults.set(25, forKey: "Age")
//
//        let savedInteger = defaults.object(forKey: "Age") as? Int ?? nil
//        print(savedInteger)
        
    }
}
