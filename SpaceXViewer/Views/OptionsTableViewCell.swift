//
//  OptionsTableViewCell.swift
//  SpaceXViewer
//
//  Created by Peter Respondek on 6/12/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import Foundation
import UIKit

class OptionsTableViewCell: UITableViewCell {
    @IBAction func switchPressed(_ sender: Any) {
        tapAction?(self)
    }
    var tapAction: ((OptionsTableViewCell) -> Void)?
    
    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var optionName: UILabel!
    
}
