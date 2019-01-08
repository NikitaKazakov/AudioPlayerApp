//
//  TrackProgressLine.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 2/27/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit

class TrackProgressLine: UIView {
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var beginLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var leadinConstraint: NSLayoutConstraint!
    @IBOutlet weak var userInteractionView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sliderView.layer.cornerRadius = sliderView.frame.height/2
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        if subviews.count == 0 {
            let view: UIView = Bundle.main.loadNibNamed(NSStringFromClass(type(of: self)).components(separatedBy: ".").last!, owner: nil, options: nil)!.first as! UIView
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        return self
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if recognizer.view != nil {
            if recognizer.location(in: userInteractionView).x >= 0 && recognizer.location(in: userInteractionView).x <= userInteractionView.frame.width{
                leadinConstraint.constant = 5 + recognizer.location(in: userInteractionView).x
                Player.shared.currentTime = TimeInterval(1.0*(recognizer.location(in: userInteractionView).x)/userInteractionView.frame.width)*Player.shared.duration
            }
        }
    }
    
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        if recognizer.view != nil {
            if recognizer.location(in: userInteractionView).x >= 0 && recognizer.location(in: userInteractionView).x <= userInteractionView.frame.width{
                leadinConstraint.constant = 5 + recognizer.location(in: userInteractionView).x
                Player.shared.currentTime = TimeInterval(1.0*(recognizer.location(in: userInteractionView).x)/userInteractionView.frame.width)*Player.shared.duration
            }
        }
    }
}
