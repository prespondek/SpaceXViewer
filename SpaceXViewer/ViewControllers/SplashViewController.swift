//
//  SplashViewController.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 5/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var time = 3.0
        if ProcessInfo.processInfo.arguments.contains("--testing") {
            time = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            self.performSegue( withIdentifier: "SplashSegue", sender: self)
        }
    }
}
