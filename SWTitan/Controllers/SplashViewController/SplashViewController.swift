//
//  SplashViewController.swift
//  SWTitan
//
//  Created by MaiMai on 5/14/16.
//  Copyright © 2016 MaiMai. All rights reserved.
//

import UIKit

class SplashViewController: ConnectionHandlingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction private func startButtonPressed(sender : UIButton) {
        let viewController = ChatBotsViewController(dataSource: FakeDataSource(count: 0, pageSize: 50))
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
}
