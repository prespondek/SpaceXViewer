//
//  LaunchTableViewCell.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 6/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import UIKit

class LaunchTableViewCell: UITableViewCell {
    @IBOutlet weak var launchName: UILabel!
    @IBOutlet weak var launchNumber: UILabel!
    @IBOutlet weak var launchSuccess: UIImageView!
    var launch: Launch? = nil {
        didSet {
            guard let field = launch else { return }
            if let flightNum = field.flightNumber {
                launchNumber.text = String(flightNum)
            } else {
                launchNumber.text = "?"
            }
            launchName.text = field.missionName ?? "???"
            if let success = field.launchSuccess  {
                if (success) {
                    launchSuccess.image = UIImage(systemName: "checkmark.seal.fill")
                    launchSuccess.tintColor = UIColor.systemGreen
                } else {
                    launchSuccess.image = UIImage(systemName: "xmark.seal.fill")
                    launchSuccess.tintColor = UIColor.systemRed
                }
                launchSuccess.isHidden = false
            } else {
                launchSuccess.isHidden = true
            }
        }
    }
}
