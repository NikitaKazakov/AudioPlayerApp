//
//  PlayerViewController.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 2/27/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit
import MarqueeLabel

class PlayerViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressLine: TrackProgressLine!
    @IBOutlet weak var animatedLabel: MarqueeLabel!
    
    @IBOutlet weak var heightConstraintForImageView: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintForImageView: NSLayoutConstraint!
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var fakePlayButton: UIButton!
    @IBOutlet weak var topConstraintForImageView: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintForImageView: NSLayoutConstraint!
    
    var trackIsPlayed: Playable?{
        willSet{
            imageView.image = newValue?.image
            animatedLabel.text = newValue?.name
            animatedLabel.speed = MarqueeLabel.SpeedLimit.duration(CGFloat(animatedLabel.text!.count/20*5))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.adjustsImageWhenHighlighted = false
        progressLine.endLabel.text = Player.shared.durationToString
        animatedLabel.animationCurve = .easeInOut
        animatedLabel.fadeLength = 10.0
        animatedLabel.leadingBuffer = 30.0
        animatedLabel.trailingBuffer = 20.0
        Player.shared.closure = updateUI
        volumeSlider.value = Player.shared.volume
        updateUI()
        setPlayButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayButtons), name: NSNotification.Name(rawValue: "kek"), object: nil)
    }
    
    func updateUI(){
        self.progressLine.leadinConstraint.constant = 5 + (self.progressLine.frame.width - 20)*CGFloat(Player.shared.normalizedTime!)
        self.progressLine.beginLabel.text = Player.shared.currentTimeToString
        self.progressLine.layoutSubviews()
        self.progressLine.setNeedsLayout()
        self.progressLine.layoutMarginsDidChange()
        self.progressLine.exerciseAmbiguityInLayout()
        self.progressLine.invalidateIntrinsicContentSize()
        self.progressLine.setNeedsDisplay()
        self.view.layoutSubviews()
    }
    
    static func instantiate(with track: Playable) -> PlayerViewController{
        let nib = UINib(nibName: "PlayerViewController", bundle: nil)
        let controller =  nib.instantiate(withOwner: self, options: nil).first as! PlayerViewController
        controller.trackIsPlayed = track
        return controller
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @objc func setPlayButtons(){
        if Player.shared.isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            fakePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            fakePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        if Player.shared.isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            fakePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            Player.shared.stop()
        } else {
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            fakePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            Player.shared.play()
        }
    }
    
    @IBAction func minusFefteenSec(_ sender: UIButton) {
        Player.shared.currentTime -= 15
        updateUI()
    }
    
    @IBAction func plusFefteenSec(_ sender: UIButton) {
        Player.shared.currentTime += 15
        updateUI()
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        Player.shared.volume = sender.value
    }
}
