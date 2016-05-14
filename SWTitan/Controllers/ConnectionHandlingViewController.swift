//
//  ConnectionHandlingViewController.swift
//  SWTitan
//
//  Created by MaiMai on 5/14/16.
//  Copyright © 2016 MaiMai. All rights reserved.
//

import UIKit

class ConnectionHandlingViewController: UIViewController {
    
    
    init() {
        super.init(nibName: String(self.dynamicType), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationController = navigationController as? NavigationViewController {
            navigationController.animationDelegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ConnectionHandlingViewController : UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransition()
    }
}