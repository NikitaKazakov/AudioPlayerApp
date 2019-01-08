//
//  AudioPlayerTableViewController.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 2/27/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit

class AudioPlayerTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var smallIconView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    let audioProvider = AudioPlayableProvider(tracks: [ Track(name: "2pac - dear mama",url: Bundle.main.url(forResource: "2pac - dear mama", withExtension: "mp3")!, image: #imageLiteral(resourceName: "2pac")),
                   Track(name: "rihanna - russian roulette",url: Bundle.main.url(forResource: "rihanna - russian roulette", withExtension: "mp3")!, image: #imageLiteral(resourceName: "rihanna")),
                   Track(name: "smash mouth - all star",url: Bundle.main.url(forResource: "smash mouth - all star", withExtension: "mp3")!, image: #imageLiteral(resourceName: "smash mouth")),
                   Track(name: "usher feat lil jon and ludacris - yeah",url: Bundle.main.url(forResource: "usher feat lil jon and ludacris - yeah", withExtension: "mp3")!, image: #imageLiteral(resourceName: "usher")),
                   Track(name: "Maryana Ro FatCat - Mega-Zvezda",url: Bundle.main.url(forResource: "Maryana Ro FatCat - Mega-Zvezda", withExtension: "mp3")!, image: #imageLiteral(resourceName: "maryana")),
                   Track(name: "Larin - 30 Let",url: Bundle.main.url(forResource: "Larin - 30 Let", withExtension: "mp3")!, image: #imageLiteral(resourceName: "larin")),
                   Track(name: "50 cent inda club",url: Bundle.main.url(forResource: "50 cent inda club", withExtension: "mp3")!, image: #imageLiteral(resourceName: "50 cent")),
                   Track(name: "snoop dogg vs david guetta - sweet",url: Bundle.main.url(forResource: "snoop dogg vs david guetta - sweet", withExtension: "mp3")!, image: #imageLiteral(resourceName: "snoop dogg")),
                   Track(name: "Kaiydo - Fruit Punch",url: Bundle.main.url(forResource: "Kaiydo - Fruit Punch", withExtension: "mp3")!, image: #imageLiteral(resourceName: "kaiydo")),
                   Track(name: "2pac all eyez on me",url: Bundle.main.url(forResource: "2pac all eyez on me", withExtension: "mp3")!, image: #imageLiteral(resourceName: "2pac all eyes on me"))]
    )
    
    var swipeInteractionController: InteractivePercentTransitionAnimator?
    var swipeForDismissInteractionController: DismissInteractivePercentTransitionAnimator?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "track")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(changePlayButton), name: NSNotification.Name(rawValue: "kek"), object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMiniPlayerButton))
        playerView.addGestureRecognizer(tap)
        swipeInteractionController = InteractivePercentTransitionAnimator(viewController: self)
        smallIconView.image = audioProvider.tracks[0].image
        playerView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return audioProvider.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "track") as! TrackTableViewCell
        cell.selectionStyle = .none
        cell.authorImage.image = audioProvider.tracks[indexPath.row].image
        cell.trackName.text = audioProvider.tracks[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        Player.shared.play(track: audioProvider.tracks[indexPath.row])
        playerView.isHidden = false
        smallIconView.image = audioProvider.tracks[indexPath.row].image
    }
    
    @objc func changePlayButton(){
        if Player.shared.isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if Player.shared.isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            Player.shared.stop()
        } else {
            playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            Player.shared.play()
        }
    }
    
    @IBAction func tapMiniPlayerButton() {
        let playerVC = PlayerViewController.instantiate(with: Player.shared.currentTrack!)
        swipeForDismissInteractionController = DismissInteractivePercentTransitionAnimator(viewController: playerVC)
        playerVC.modalPresentationStyle = .overCurrentContext
        playerVC.transitioningDelegate = self
        self.present(playerVC, animated: true, completion: nil)
    }
}

extension AudioPlayerTableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresetnAnimationController(originFrame: playerView.frame)
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let a = swipeInteractionController?.interactionInProgress, a  else {
            return nil
        }
        return swipeInteractionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let a = swipeForDismissInteractionController?.interactionInProgress, a  else {
            return nil
        }
        return swipeForDismissInteractionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimationController(originFrame: dismissed.view.frame)//return DismissAnimationController(originFrame: playerVC!.view.frame)
    }
}
