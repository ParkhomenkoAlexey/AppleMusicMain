//
//  PlayerDetailsView.swift
//  PodcastsCourseLBTA
//
//  Created by Алексей Пархоменко on 06/08/2019.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit
import AVKit

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardForNextTrack()  -> SearchViewModel.Cell?
}

class PlayerDetailsView: UIView {
    
    // MARK: - @IBOutlets and properties
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
        }
    }
    @IBOutlet weak var miniGoForwardButton: UIButton!
    @IBOutlet weak var miniPlayerView: UIView!
    
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    
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
    
    var panGesture: UIPanGestureRecognizer!

    // MARK: - awakeFromNib
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        addGestureRecognizer(panGesture)
        miniPlayerView.addGestureRecognizer(panGesture)
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        print("maxi")
        
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackView.transform = .identity
                
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizePlayerDetails()
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackTitleLabel.numberOfLines = 2
        trackImageView.layer.cornerRadius = 5
        miniTrackImageView.layer.cornerRadius = 3
        currentTimeSlider.minimumTrackTintColor = #colorLiteral(red: 0.464419961, green: 0.5312339664, blue: 0.5431776643, alpha: 1)
        currentTimeSlider.setThumbImage(#imageLiteral(resourceName: "Knob"), for: .normal)
        
        setupGestures()
    }

    // MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        miniTrackTitleLabel.text = viewModel.trackName
        
        playTrack(previewUrl: viewModel.previewUrl, trackName: viewModel.trackName)

        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        miniTrackImageView.sd_setImage(with: url, completed: nil)
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
    // self has a reference to player
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
    // MARK: - Animations trackImageView
    
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
    
    // MARK: - handleDismiss @IBAction
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.tabBarDelegate?.minimizePlayerDetails()
//        panGesture.isEnabled = true
        
    }
    
    // MARK: - @IBActions
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
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
        let cellViewModel = delegate?.moveBackForPreviousTrack()
        self.set(viewModel: cellViewModel!)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveForwardForNextTrack()
        self.set(viewModel: cellViewModel!)
    }
    
    @IBAction func handleVolumeChange(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
}

    // MARK: - Maximizing and Minimizing gestures
extension PlayerDetailsView {

    @objc func handleTapMaximize() {
        print("tapping to maximize")
        tabBarDelegate?.maximizePlayerDetails(viewModel: nil)
//        panGesture.isEnabled = false
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        print("Panning")
        if gesture.state == .began {
            print("Began")
        } else if gesture.state == .changed {
            print("changed")
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        //        self.miniPlayerView.alpha = 1 + translation.y / 200
        let newAlpha = 1 + translation.y / 200
        self.miniPlayerView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        print("ended")
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizePlayerDetails(viewModel: nil)
//                gesture.isEnabled = false
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
                
            }
        })
    }
}
