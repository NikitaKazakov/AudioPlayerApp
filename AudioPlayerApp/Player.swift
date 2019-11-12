//
//  Player.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 2/27/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import AVFoundation

class Player: NSObject {
    
    static var shared: Player = Player()
    private var player: AVAudioPlayer?
    
    var closure: (()->())? = nil
    var currentTrack: Playable?
    var currentTime: TimeInterval {
        set{
            if newValue >= player!.duration {
                player?.currentTime = player!.duration - 1
                return
            }
            player?.currentTime = newValue
        }
        
        get{
            return player!.currentTime
        }
    }
    
    var volume: Float = 1 {
        willSet{
            player?.volume = newValue
        }
    }
    
    var duration: TimeInterval {
        get{
            return player!.duration
        }
    }
    
    var normalizedTime: Float? {
        return Float((player?.currentTime)! / (player?.duration)!)
    }

    var durationToString: String?  {
        let ti = NSInteger((player?.duration) ?? 0)
        let seconds = ti % 60
        let minutes = (ti / 60)

        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }

    var currentTimeToString: String? {
        let ti = NSInteger((player?.currentTime)!)
        let seconds = ti % 60
        let minutes = (ti / 60)

        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    var isPlaying: Bool {
        get {
            return player?.isPlaying ?? false
        }
    }
    
    
    func play(track: Playable){
        if let _ = player?.isPlaying {
            player?.stop()
        }
        do{
            player = try AVAudioPlayer(contentsOf: track.url)
            currentTrack = track
            player?.delegate = self
            player?.volume = volume
            let updater = CADisplayLink(target: Player.shared, selector: #selector(trackAudio))
            updater.preferredFramesPerSecond = 1
            updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            Player.shared.play()
        } catch {
            // Error
            print("ERORR")
        }
    }
    
    func play(){
        player?.play()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.allowAirPlay)
        } catch {
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kek"), object: nil)
    }
    
    func stop(){
        player?.stop()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kek"), object: nil)
    }
    
    @objc func trackAudio() {
        guard let _ = closure else { return }
        closure!()
    }

}

extension Player: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kek"), object: nil)
    }
}
