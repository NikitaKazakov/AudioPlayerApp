//
//  DismissAnimationController.swift
//  AudioPlayerApp
//
//  Created by Nikita Kazakov on 3/10/18.
//  Copyright © 2018 Nikita Kazakov. All rights reserved.
//

import Foundation
import UIKit


class DismissAnimationController:  NSObject, UIViewControllerAnimatedTransitioning{
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? PlayerViewController, let toVC = transitionContext.viewController(forKey: .to) as? UITabBarController
            else {
                return
        }
        let finalFrame = CGRect(x: toVC.tabBar.frame.origin.x, y: toVC.tabBar.frame.origin.y - 50 - toVC.tabBar.frame.height, width: toVC.tabBar.frame.width, height: 50)
    
        fromVC.view.layer.masksToBounds = true
        let duration = transitionDuration(using: transitionContext)
        fromVC.heightConstraintForImageView.constant = min(fromVC.view.frame.height - 340, fromVC.view.frame.width - 40)
        fromVC.widthConstraintForImageView.constant = min(fromVC.view.frame.height - 340, fromVC.view.frame.width - 40)
        fromVC.leadingConstraintForImageView.constant = (fromVC.view.frame.width - min(fromVC.view.frame.height - 340, fromVC.view.frame.width - 40))/2
        fromVC.topConstraintForImageView.constant = 5
        fromVC.topConstraintForImageView.constant = -5
        fromVC.view.layoutIfNeeded()
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    fromVC.view.frame = finalFrame
                    toVC.tabBar.frame.origin.y -= toVC.tabBar.frame.height
                }
                UIView.addKeyframe(withRelativeStartTime: 0.45, relativeDuration: 1) {
                    fromVC.heightConstraintForImageView.constant = 40
                    fromVC.widthConstraintForImageView.constant = 40
                    if UIScreen.main.nativeBounds.height == 2436 {
                        fromVC.topConstraintForImageView.constant = -40
                    } else {
                        fromVC.topConstraintForImageView.constant = -15
                    }
                    fromVC.leadingConstraintForImageView.constant = 10
                    fromVC.view.layoutIfNeeded()
                }
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                    fromVC.fakePlayButton.alpha = 1
                }
        },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
