//
//  CrossDissolveTransition.swift
//  SWTitan
//
//  Created by MaiMai on 5/14/16.
//  Copyright © 2016 MaiMai. All rights reserved.
//

import UIKit

class CrossDissolveTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        toViewController.view.frame = transitionContext.initialFrameForViewController(fromViewController)
        containerView.addSubview(toViewController.view)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromViewController.view.alpha = 0
            toViewController.view.alpha = 1
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext .transitionWasCancelled())
        })
    }
}
