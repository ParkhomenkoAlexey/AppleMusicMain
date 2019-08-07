//
//  PlayerDetailsView.swift
//  PodcastsCourseLBTA
//
//  Created by Алексей Пархоменко on 06/08/2019.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit
import AVKit

//protocol NewsfeedCodeCellDelegate: class {
//    func revealPost(for cell: NewsfeedCodeCell)
//}

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack()
    func moveForwardForNextTrack()
}

class PlayerDetailsView: UIView {
    
    // MARK: - @IBOutlets and properties
    
    weak var delegate: TrackMovingDelegate?
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView! {
        didSet {
            let scale: CGFloat = 0.8
            trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    // MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackTitleLabel.numberOfLines = 2
        trackImageView.layer.cornerRadius = 5
        currentTimeSlider.minimumTrackTintColor = #colorLiteral(red: 0.464419961, green: 0.5312339664, blue: 0.5431776643, alpha: 1)
        currentTimeSlider.setThumbImage(#imageLiteral(resourceName: "Knob"), for: .normal)
    }
    
    // MARK: - Setup
    
    
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        
    
        playTrack(previewUrl: viewModel.previewUrl, trackName: viewModel.trackName)

        
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        observePlayerCurrentTime()
        monitorStartTime()
    }
    
    private func playTrack(previewUrl: String?, trackName: String) {
        
//        print("Trying to play track at url:", previewUrl ?? "No previewUrl")
        guard let url = URL(string: previewUrl ?? "") else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        player.play()
        print("Track started playing:", trackName)
    }
    
    // MARK: - Time setup, 16 и 17 Урок: Monitor Start Time & Tracking Playback Time
    
    // player has a reference to self
    /// self has a reference to player
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationText)"
//            self?.durationLabel.text = (durationTime ?? CMTimeMake(value: 1, timescale: 1) - time).toDisplayString()
            self?.updateCurrentTimeSlider()
        }
    }
    
    deinit {
        print("PlayerDetailsView memory being reclaimed...")
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    // MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func shrinkTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    // MARK: - @IBActions
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkTrackImageView()
        }
    }
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
//        print("currentTimeSlider.value:", currentTimeSlider.value)
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
//        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        player.seek(to: seekTime)
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        delegate?.moveBackForPreviousTrack()
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        delegate?.moveForwardForNextTrack()
    }
    
    @IBAction func handleVolumeChange(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
}
