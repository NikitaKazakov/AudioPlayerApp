//
//  PresentAnimationController.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 3/9/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit

class PresetnAnimationController:  NSObject, UIViewControllerAnimatedTransitioning{
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? PlayerViewController
            else {
                return
        }
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        toVC.view.frame = originFrame
        toVC.view.layer.masksToBounds = true
        containerView.addSubview(toVC.view)
        let duration = transitionDuration(using: transitionContext)
        toVC.heightConstraintForImageView.constant = 40
        toVC.widthConstraintForImageView.constant = 40
        //toVC.topConstraintForImageView.constant = 5
        toVC.leadingConstraintForImageView.constant = 10
        toVC.animatedLabel.alpha = 0
        toVC.view.layoutIfNeeded()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    toVC.view.frame = finalFrame
                    toVC.heightConstraintForImageView.constant = min(finalFrame.height - 340, finalFrame.width - 40)
                    toVC.widthConstraintForImageView.constant = min(finalFrame.height - 340, finalFrame.width - 40)
                    //toVC.topConstraintForImageView.constant = 5
                    toVC.leadingConstraintForImageView.constant = (finalFrame.width - min(finalFrame.height - 340, finalFrame.width - 40))/2
                    (fromVC as? UITabBarController)?.tabBar.frame.origin.y += (fromVC as? UITabBarController)?.tabBar.frame.height ?? 0
                    toVC.view.layoutIfNeeded()
                }
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3) {
                    toVC.fakePlayButton.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 1/3 + 1/4, relativeDuration: 2/3 + 1/4) {
                    toVC.animatedLabel.alpha = 1
                }
        },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                toVC.view.layoutIfNeeded()
        })
    }
    
}
