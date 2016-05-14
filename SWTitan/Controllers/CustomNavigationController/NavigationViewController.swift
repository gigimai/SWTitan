//
//  NavigationViewController.swift
//  SWTitan
//
//  Created by MaiMai on 5/14/16.
//  Copyright © 2016 MaiMai. All rights reserved.
//

import UIKit
import ChameleonFramework

class NavigationViewController: UINavigationController {
    
    var isPushingViewController = false
    weak var animationDelegate : UINavigationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        //Customize navigation bar
        navigationBar.barTintColor = UIColor.flatBlueColor()
        navigationBar.tintColor    = UIColor.flatWhiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.flatWhiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 15.0)!]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        guard isPushingViewController else {
            super.pushViewController(viewController, animated: animated)
            return
        }
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        guard isPushingViewController else {
            return super.popViewControllerAnimated(animated)
        }
        return nil
    }
    
    override func setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        guard isPushingViewController else {
            super.setViewControllers(viewControllers, animated: animated)
            return
        }
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        guard isPushingViewController else {
            return super.popToRootViewControllerAnimated(animated)
        }
        return nil
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard isPushingViewController else {
            return popToViewController(viewController, animated: animated)
        }
        return nil
    }
    
}

extension NavigationViewController : UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        isPushingViewController = false
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        isPushingViewController = true
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationDelegate?.navigationController?(navigationController, animationControllerForOperation: operation, fromViewController: fromVC, toViewController: toVC) ?? CrossDissolveTransition()
    }
    
}

